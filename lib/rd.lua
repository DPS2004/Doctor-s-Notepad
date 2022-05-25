local rd = {}





function rd.load(filename,extensions)
    local level = {}
    level.data = dpf.loadjson(filename, {}, true)
	
    level.decorations = {}
    level.decoid = 0
    level.eos = 0
	
	level.eventy = {}
	level.ceventy = -1
	
	level.eventyblacklist = {
		MoveRoom=true, 
		SetRoomContentMode=true
	}

    level.fakeevents = {}
	
	level.fakehandlers = {}
	
	
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
	


    -- save level to file, and resolve fake events
	
	function level:fakehandler(etype,efunc)
		self.fakehandlers[etype] = efunc
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

        for i, v in ipairs(self.decorations) do
            v:save()
        end

        dpf.saverdlevel(filename, self.data)
    end

    return level
end

return rd
