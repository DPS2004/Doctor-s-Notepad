local rd = {}



function rd.load(filename,extensions)
    local level = {}
    level.data = dpf.loadjson(filename, {}, true)
	
    level.eos = 0
	
	level.eventy = {}
	level.ceventy = -1
	
	level.eventyblacklist = {
		MoveRoom=true, 
		SetRoomContentMode=true
	}

    level.fakeevents = {}
	
	level.fakehandlers = {}
	
	level.condensers = {}
	
	
	level.initqueue = deeper.init()

	for i,v in ipairs(extensions) do
		local ext = dofile('extensions/'..v..'.lua')
		print('loading extension '..v)
		ext(level)
	end
	
	
	

    function level:init(beat)
        
		self.initqueue.execute(self,beat)
		
    end

    function level:offset(eos)
        self.eos = eos
    end
	
	
    -- convert beatnumber (0 indexed) to bar measure pair (1 indexed)
    function level:getbm(inbeat)
        local crotchet = 8
        local bar = 1
        local beat = 1
        local cbeat = 0

        local remainder = inbeat - math.floor(inbeat)
        inbeat = math.floor(inbeat)

        local crotchetevents = {}

        for eventi, event in ipairs(self.data.events) do
            if event.type == "SetCrotchetsPerBar" then
                table.insert(crotchetevents, event)
            end
        end

        while true do
            if cbeat == inbeat then
                break
            end

            for eventi, event in ipairs(crotchetevents) do
                if event.bar == bar and event.beat == beat then
                    crotchet = event.crotchetsPerBar
                end
            end

            beat = beat + 1
            if beat > crotchet then
                bar = bar + 1
                beat = 1
            end

            cbeat = cbeat + 1
        end
        return bar, beat + remainder
    end
	
	-- add an arbitrary event
    function level:addevent(beat, event, params)
        local newevent = {}
		beat = beat + self.eos
        newevent.bar, newevent.beat = self:getbm(beat)
		newevent.truebeat = beat
        newevent.type = event
		params = params or {}
        if not params.y then
			if not self.eventyblacklist[event] then
				if self.eventy[event] then
					params.y = self.eventy[event]
				else
					self.ceventy = (self.ceventy + 1)%4
					self.eventy[event] = self.ceventy
					params.y = self.ceventy
				end
			end
		end
        for k, v in pairs(params) do
            newevent[k] = v
        end

        table.insert(self.data.events, newevent)
    end

    -- add fake event, to be turned into a real event upon saving
    function level:addfakeevent(beat, event, params)
        params = params or {}
        local newevent = {}		
		
		newevent.beat = beat
        newevent.type = event
		
        for k, v in pairs(params) do
            newevent[k] = v
        end
		if newevent.duration == 0 and newevent.beat + self.eos ~= 0 then
			self:makereal(newevent)
		else
			newevent.beat = newevent.beat + self.eos
			table.insert(self.fakeevents, newevent)
		end
        
    end
    


    -- wrap single room number in a table
    function level:roomtable(room)
        local rtable = nil
        if type(room) == "number" then
            rtable = {room}
        elseif room.index then
			rtable = {room.index}
		else
            rtable = room
        end
        return rtable
    end
	
	
	-- quick function made for level:getcondensable to check whether two tables are equal, useful for stuff like the 'rooms' property some events have
	local function tablesequal(t1, t2)
		for k,v in pairs(t1) do
			if v ~= t2[k] then
				if type(v) == 'table' and t2[k] == 'table' then
					local eq=tablesequal(v,t2[k])
					if not eq then return false end
				else
					return false
				end
			end
		end
		return true
	end	

    -- save level to file, and resolve fake events
	
	function level:getcondensable(elist,equalchecks)
		local groups = {}
		
		for i,v in ipairs(elist) do
			local foundmatch = false
			
			for _i,group in ipairs(groups) do
				if not foundmatch then
					local thismatches = true
					for __i,q in ipairs(equalchecks) do
						if group[1][q] ~= v[q] then
							if(type(group[1][q]) == 'table' and type(v[q]) == 'table') then
								local equals = tablesequal(group[1][q], v[q])
								if not equals then
									thismatches = false
								end
							else
								thismatches = false
							end
						end
					end
					if thismatches then
						foundmatch = true
						table.insert(group,v)
					end
				end
			end
			
			if not foundmatch then
				table.insert(groups,{v})
			end
			
		end
		
		return groups
	end
	
	
	function level:mergegroup(group)
		local newevent = {}
		
		
		
		for ei, event in ipairs(group) do
			for eprop,epval in pairs(event) do --TODO: make this recursive?
				if type(epval) == 'table' then
					newevent[eprop] = newevent[eprop] or {}
					for i,v in ipairs(epval) do
						if v == null then
							if not newevent[eprop][i] then
								newevent[eprop][i] = null
							end
						else
							newevent[eprop][i] = v
						end
					end
				else
					if epval == null then
						if not newevent[eprop] then
							newevent[eprop] = null
						end
					else
						newevent[eprop] = epval
					end
				end
			end
		end
		
		return newevent
	end
	
	function level:condenser(etype,func)
		self.condensers[etype] = func
	end
	function level:fakehandler(etype,func)
		self.fakehandlers[etype] = func
	end
	
	function level:makereal(v)
		if self.fakehandlers[v.type] then
			self.fakehandlers[v.type](self,v)
		end
	end
	
	
	function level:push(beat)
		self.eos = 0
        for i, v in ipairs(self.fakeevents) do
            self:makereal(v)
        end
		
		if beat then
			self.fakeevents = {}
			self.rows = {}
			self.rooms = {}
			self:init(beat)
		end
	end
	
    function level:save(filename)
		
		self:push()

        for k,v in pairs(self.decorations) do
            v:save()
        end
		
		--event condenser
		local typesort = {}
		local beatsort = {}
		local condensedevents = {}
		
		for i,v in ipairs(self.data.events) do
			if typesort[v.type] then
				table.insert(typesort[v.type],v)
			else
				typesort[v.type] = {v}
				beatsort[v.type] = {}
			end
		end
		
		for k,v in pairs(typesort) do
			print('new type: '..k)
			for i, event in ipairs(v) do
				local tb = event.truebeat
				if tb then
					if beatsort[k][tb] then
						event.truebeat = nil
						table.insert(beatsort[k][tb],event)
					else
					
						event.truebeat = nil
						beatsort[k][tb] = {event}
					end
				else --dont condense events that were not generated by DN
					table.insert(condensedevents,event)
				end
			end
		end
		
		for etype,ebeats in pairs(beatsort) do
			print('condensing type '..etype)
			if self.condensers[etype] then
				print('found matching condenser')
				for ebeat,elist in pairs(ebeats) do
					print('condensing beat '.. ebeat)
					local condensed = self.condensers[etype](self,elist)
					for i,v in ipairs(condensed) do
						table.insert(condensedevents,v)
					end
				end
			else
				for ebeat,elist in pairs(ebeats) do
					for i,v in ipairs(elist) do
						table.insert(condensedevents,v)
					end
				end
			end
		end
		
		self.data.events = condensedevents

        dpf.saverdlevel(filename, self.data)
    end

    return level
end

return rd
