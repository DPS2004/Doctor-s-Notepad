local rd = {}

function rd.load(filename)
    local level = {}
    level.data = dpf.loadjson(filename, {}, true)

    level.rows = {}
    level.rooms = {}
    level.decorations = {}
    level.decoid = 0
    level.eos = 0

    level.fakeevents = {}

    function level:init(beat)
        for i, v in ipairs(self.data.rows) do
            local oldroom = v.rooms[1]

            v.rooms = self:roomtable(0)
            local newrow = self:getrow(v.row)

            setvalue(newrow, "room", 0, oldroom)
			if not beat then
				self:addfakeevent(0, "updaterowx", {row = v.row, duration = 0, ease = "Linear"})
				self:addfakeevent(0, "updaterowy", {row = v.row, duration = 0, ease = "Linear"})
				self:addfakeevent(0, "updaterowpivot", {row = v.row, duration = 0, ease = "Linear"})
			end
        end
        for i = 0, 4 do
            local newroom = self:getroom(i)
			if (not beat) and (i ~= 4) then
			
				self:addfakeevent(0, "updateroomx", {room = i, duration = 0, ease = "Linear"})
				self:addfakeevent(0, "updateroomy", {room = i, duration = 0, ease = "Linear"})
				self:addfakeevent(0, "updateroomscale", {room = i, duration = 0, ease = "Linear"})
				self:addfakeevent(0, "updateroommode", {room = i, duration = 0, ease = "Linear"})
			end
        end
    end

    function level:offset(eos)
        self.eos = eos
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

    -- create row object from index
    function level:getrow(index)
        if level.rows[index] then
            return level.rows[index]
        end

        local row = {}
        row.level = self
        row.data =
            tget(
            self.data.rows,
            function(v)
                return v.row == index
            end
        )
        -- set up persistent value timelines that can be accessed by other commands
        row.values = {
            room = {{beat = 0, state = 0}},
            x = {{beat = 0, state = 50}},
            y = {{beat = 0, state = 50}},
            sx = {{beat = 0, state = 100}},
            sy = {{beat = 0, state = 100}},
            pivot = {{beat = 0, state = 0.5}},
            rot = {{beat = 0, state = 0}},
            --tint row
            border = {{beat = 0, state = "None"}},
            bordercolor = {{beat = 0, state = "000000"}},
            borderopacity = {{beat = 0, state = 100}},
            tint = {{beat = 0, state = false}},
            tintcolor = {{beat = 0, state = "FFFFFF"}},
            tintopacity = {{beat = 0, state = 100}},
            hidden = {{beat = 0, state = false}},
            electric = {{beat = 0, state = false}}
        }

        function row:setroom(beat, room)
            setvalue(self, "room", beat, room)
            self.level:addfakeevent(beat, "updaterowx", {row = index, duration = 0, ease = "Linear"})
        end

        function row:movex(beat, x, duration, ease)
            duration = duration or 0
            ease = ease or "Linear"
            setvalue(self, "x", beat, x)
            self.level:addfakeevent(beat, "updaterowx", {row = index, duration = duration, ease = ease})
        end

        function row:movey(beat, y, duration, ease)
            duration = duration or 0
            ease = ease or "Linear"
            setvalue(self, "y", beat, y)
            self.level:addfakeevent(beat, "updaterowy", {row = index, duration = duration, ease = ease})
        end
		function row:movesx(beat, x, duration, ease)
            duration = duration or 0
            ease = ease or "Linear"
            setvalue(self, "sx", beat, x)
            self.level:addfakeevent(beat, "updaterowsx", {row = index, duration = duration, ease = ease})
        end

        function row:movesy(beat, y, duration, ease)
            duration = duration or 0
            ease = ease or "Linear"
            setvalue(self, "sy", beat, y)
            self.level:addfakeevent(beat, "updaterowsy", {row = index, duration = duration, ease = ease})
        end
		function row:rotate(beat, rot, duration, ease)
            duration = duration or 0
            ease = ease or "Linear"
            setvalue(self, "rot", beat, rot)
            self.level:addfakeevent(beat, "updaterowrot", {row = index, duration = duration, ease = ease})
        end

        function row:movepivot(beat, pivot, duration, ease)
            duration = duration or 0
            ease = ease or "Linear"
            setvalue(self, "pivot", beat, pivot)
            self.level:addfakeevent(beat, "updaterowpivot", {row = index, duration = duration, ease = ease})
        end

        function row:move(beat, p, duration, ease)
            duration = duration or 0
            ease = ease or "Linear"
            for k, v in pairs(p) do
                if k == "x" then
                    self:movex(beat, v, duration, ease)
                elseif k == "y" then
                    self:movey(beat, v, duration, ease)
				elseif k == "sx" then
                    self:movesx(beat, v, duration, ease)
				elseif k == "sy" then
                    self:movesy(beat, v, duration, ease)
                elseif k == "pivot" then
                    self:movepivot(beat, v, duration, ease)
				elseif k == "rotate" or k == "rot" then
                    self:rotate(beat, v, duration, ease)
                end
            end
        end

        -- set hideAtStart
        function row:setvisibleatstart(vis)
            if vis == nil then
                vis = false
            end
            vis = not vis

            self.data.hideAtStart = vis

            setvalue(self, "hidden", 0, vis)

            self:save()
        end

        function row:setborder(beat, bordertype, color, opacity, duration, ease)
            color = color or "000000"
            opacity = opacity or 100
            duration = duration or 0
            ease = ease or "linear"
            setvalue(self, "border", beat, bordertype)
            setvalue(self, "bordercolor", beat, color)
            setvalue(self, "borderopacity", beat, opacity)

            self.level:addfakeevent(beat, "updatetint", {duration = duration, ease = ease, row = index})
        end

        function row:settint(beat, showtint, color, opacity, duration, ease)
            color = color or "FFFFFF"
            opacity = opacity or 100
            duration = duration or 0
            ease = ease or "linear"
            setvalue(self, "tint", beat, showtint)
            setvalue(self, "tintcolor", beat, color)
            setvalue(self, "tintopacity", beat, opacity)

            self.level:addfakeevent(beat, "updatetint", {duration = duration, ease = ease, row = index})
        end

        --save to level
        function row:save()
            tset(
                self.level.data.rows,
                function(v)
                    return v.row == index
                end,
                self
            )
        end

        level.rows[index] = row

        return row
    end

    -- create room objects from index
    function level:getroom(index)
        if level.rooms[index] then
            return level.rooms[index]
        end

        local room = {}
        room.level = self
        room.index = index
        room.values = {
            x = {{beat = 0, state = 50}},
            y = {{beat = 0, state = 50}},
            sx = {{beat = 0, state = 100}},
            sy = {{beat = 0, state = 100}},
			px = {{beat = 0, state = 50}},
            py = {{beat = 0, state = 50}},
            stretch = {{beat = 0, state = true}},
			xflip = {{beat = 0, state = false}},
			yflip = {{beat = 0, state = false}},
			--camera
			camx = {{beat = 0, state = 50}},
			camy = {{beat = 0, state = 50}},
			camzoom = {{beat = 0, state = 100}},
			camrot = {{beat = 0, state = 0}},
            --boolean presets
            Sepia = {{beat = 0, state = false}},
            VHS = {{beat = 0, state = false}},
            --other presets
            abberation = {{beat = 0, state = false}},
            abberationintensity = {{beat = 0, state = 0}},
			grain = {{beat = 0, state = false}},
            grainintensity = {{beat = 0, state = 100}}
        }
		--move rooms
        function room:movex(beat, x, duration, ease)
            duration = duration or 0
            ease = ease or "Linear"
            setvalue(self, "x", beat, x)
            self.level:addfakeevent(beat, "updateroomx", {room = index, duration = duration, ease = ease})
        end

        function room:movey(beat, y, duration, ease)
            duration = duration or 0
            ease = ease or "Linear"
            setvalue(self, "y", beat, y)
            self.level:addfakeevent(beat, "updateroomy", {room = index, duration = duration, ease = ease})
        end

        function room:movesx(beat, sx, duration, ease)
            duration = duration or 0
            ease = ease or "Linear"
            setvalue(self, "sx", beat, sx)
            self.level:addfakeevent(beat, "updateroomscale", {room = index, duration = duration, ease = ease})
        end

        function room:movesy(beat, sy, duration, ease)
            duration = duration or 0
            ease = ease or "Linear"
            setvalue(self, "sy", beat, sy)
            self.level:addfakeevent(beat, "updateroomscale", {room = index, duration = duration, ease = ease})
			
        end
		
		function room:movepx(beat, px, duration, ease)
            duration = duration or 0
            ease = ease or "Linear"
            setvalue(self, "px", beat, px)
            self.level:addfakeevent(beat, "updateroompivot", {room = index, duration = duration, ease = ease})
        end

        function room:movepy(beat, py, duration, ease)
            duration = duration or 0
            ease = ease or "Linear"
            setvalue(self, "py", beat, py)
            self.level:addfakeevent(beat, "updateroompivot", {room = index, duration = duration, ease = ease})
			
        end
		
		

        function room:move(beat, p, duration, ease)
            duration = duration or 0
            ease = ease or "Linear"
            for k, v in pairs(p) do
                if k == "x" then
                    self:movex(beat, v, duration, ease)
                elseif k == "y" then
                    self:movey(beat, v, duration, ease)
                elseif k == "sx" then
                    self:movesx(beat, v, duration, ease)
                elseif k == "sy" then
                    self:movesy(beat, v, duration, ease)
				elseif k == "px" then
                    self:movepx(beat, v, duration, ease)
                elseif k == "py" then
                    self:movepy(beat, v, duration, ease)
                end
            end
        end
		
		--move cams
		function room:camx(beat, x, duration, ease)
            duration = duration or 0
            ease = ease or "Linear"
            setvalue(self, "camx", beat, x)
            self.level:addfakeevent(beat, "updatecamx", {room = index, duration = duration, ease = ease})
        end

        function room:camy(beat, y, duration, ease)
            duration = duration or 0
            ease = ease or "Linear"
            setvalue(self, "camy", beat, y)
            self.level:addfakeevent(beat, "updatecamy", {room = index, duration = duration, ease = ease})
        end

        function room:camzoom(beat, z, duration, ease)
            duration = duration or 0
            ease = ease or "Linear"
            setvalue(self, "camzoom", beat, z)
            self.level:addfakeevent(beat, "updatecamzoom", {room = index, duration = duration, ease = ease})
        end
		function room:camrot(beat, z, duration, ease)
            duration = duration or 0
            ease = ease or "Linear"
            setvalue(self, "camrot", beat, z)
            self.level:addfakeevent(beat, "updatecamrot", {room = index, duration = duration, ease = ease})
        end
		
		function room:cam(beat, p, duration, ease)
            duration = duration or 0
            ease = ease or "Linear"
            for k, v in pairs(p) do
                if k == "x" then
                    self:camx(beat, v, duration, ease)
                elseif k == "y" then
                    self:camy(beat, v, duration, ease)
                elseif k == "zoom" or k == "z" then
                    self:camzoom(beat, v, duration, ease)
                elseif k == "rot" or k == 'r' then
                    self:camrot(beat, v, duration, ease)
                end
            end
        end
		
		
		--flip
		function room:xflip(beat,state)
			if state == nil then
				state = not getvalue(self, "xflip", beat)
			end
			setvalue(self,'xflip',beat,state)
			self.level:addfakeevent(beat,'updateroomflip', {room = index})
		end
		
		function room:yflip(beat,state)
			if state == nil then
				state = not getvalue(self, "yflip", beat)
			end
			setvalue(self,'yflip',beat,state)
			self.level:addfakeevent(beat,'updateroomflip', {room = index})
		end

        -- change content mode
        function room:stretchmode(beat, state)
            state = state or not getvalue(self, "stretch", beat)
			setvalue(self,'stretch',beat,stretch)
            self.level:addfakeevent(beat, "updateroommode", {room = index})
        end

        -- set theme
        function room:settheme(beat, theme)
            self.level:addevent(beat, "SetTheme", {rooms = self.level:roomtable(index), preset = theme})
        end

        --abberation
        function room:abberation(beat, state, intensity, duration, ease)
            duration = duration or 0
            ease = ease or "Linear"

            state = state or not getvalue(self, "abberation", beat)
            intensity = intensity or getvalue(self, "abberationintensity", beat)

            setvalue(self, "abberation", beat, state)
            setvalue(self, "abberationintensity", beat, intensity)
            self.level:addevent(
                beat,
                "SetVFXPreset",
                {
                    rooms = self.level:roomtable(index),
                    preset = "Aberration",
                    enable = state,
                    intensity = intensity,
                    duration = duration,
                    ease = ease
                }
            )
        end
		-- grain
		function room:grain(beat, state, intensity, duration, ease)
            duration = duration or 0
            ease = ease or "Linear"

            state = state or not getvalue(self, "grain", beat)
            intensity = intensity or getvalue(self, "grainintensity", beat)

            setvalue(self, "grain", beat, state)
            setvalue(self, "grainintensity", beat, intensity)
            self.level:addevent(
                beat,
                "SetVFXPreset",
                {
                    rooms = self.level:roomtable(index),
                    preset = "Grain",
                    enable = state,
                    intensity = intensity,
                    duration = duration,
                    ease = ease
                }
            )
        end

        -- set or toggle a boolean vfx preset
        function room:setpreset(beat, preset, state)
            state = state or not getvalue(self, preset, beat)
            setvalue(self, preset, beat, state)
            self.level:addevent(
                beat,
                "SetVFXPreset",
                {rooms = self.level:roomtable(index), preset = preset, enable = state}
            )
        end

        --preset shorthands
        function room:sepia(beat, state)
            self:setpreset(beat, "Sepia", state)
        end
        function room:vhs(beat, state)
            self:setpreset(beat, "VHS", state)
        end
		
		function room:flash(beat,startcolor,startopacity,endcolor,endopacity,duration,ease,bg)
			self.level:customflash(beat,index,startcolor,startopacity,endcolor,endopacity,duration,ease,bg)
		end
		
		function room:screentile(beat,x,y)
			self.level:screentile(beat,index,x,y)
		end
		
		function room:screenscroll(beat,x,y)
			self.level:screenscroll(beat,index,x,y)
		end
		function room:pulsecamera(beat,count,frequency,strength)
			self.level:pulsecamera(beat,index,count,frequency,strength)
		end
		
		--bg
		
		function room:setbg(beat,filename,mode,sx,sy,color)
			if sx or sy then
				mode = 'Tiled'
			end
			mode = mode or 'ScaleToFill'
			sx = sx or 0
			sy = sy or 0
			color = color or 'ffffffff'
			self.level:addevent(
                beat,
                "SetBackgroundColor",
                {rooms = self.level:roomtable(index),
				backgroundType = 'Image',
				contentMode = mode,
				color = color,
				image = {filename},
				fps = 30,
				filter = 'NearestNeighbor',
				scrollX = sx,
				scrollY = sy
				}
            )
		end
		
		
        -- new decoration
        function room:newdecoration(filename, depth)
            filename = filename or ""
            depth = depth or ""
            self.level.data.decorations = self.level.data.decorations or {}

            local deco = {}
            deco.id = "deco_" .. self.level.decoid
            deco.row = self.level.decoid
            deco.room = self
            deco.filename = filename
            deco.depth = depth
            self.level.decoid = self.level.decoid + 1

            function deco:save()
                table.insert(
                    self.room.level.data.decorations,
                    {
                        id = self.id,
                        row = self.row,
                        rooms = self.room.level:roomtable(self.index),
                        filename = self.filename,
                        depth = self.depth,
                        visible = false
                    }
                )
            end

            table.insert(self.level.decorations, deco)

            return deco
        end

        --save to level
        function room:save()
        end

        level.rooms[index] = room

        return room
    end

    -- cues

    function level:cue(beat, ctype, tick)
        ctype = ctype or "SayGetSetGo"
        tick = tick or 1
        self:addevent(beat, "SayReadyGetSetGo", {phraseToSay = ctype, tick = tick, voiceSource = "Nurse", volume = 100})
    end

    --custom methods

    function level:rdcode(beat, code,extime)
        beat = beat or 0
		extime = extime or "OnBar"
        self:addevent(beat, "CallCustomMethod", {methodName = code, executionTime = "OnBar", sortOffset = 0})
    end
	
	--bpm
	function level:setbpm(beat, bpm)
        self:addevent(beat, "SetBeatsPerMinute", {beatsPerMinute = bpm})
    end
	
	--sound + songs
	function level:playsound(beat, sound,offset,soundtype)
		offset = offset or 0
		soundtype = soundtype or "MusicSound"
        self:addevent(beat, "PlaySound", {filename = sound, volume = 100, pitch = 100, pan = 0, offset = offset, isCustom = true, customSoundType = soundtype })
    end

    -- set all rooms to transparent
    function level:setuprooms(beat)
        beat = beat or 0
        self:addevent(
            beat,
            "SetBackgroundColor",
            {
                rooms = {0, 1, 2, 3},
                backgroundType = "Color",
                contentMode = "ScaleToFill",
                color = "FFFFFF00",
                image = {},
                filter = "NearestNeighbor",
                scrollX = 0,
                scrollY = 0
            }
        )
    end
	
	--reorder rooms (find a cleaner solution later)
	function level:reorderrooms(beat,r1,r2,r3,r4)
		beat = beat or 0
		self:addevent(
			beat,
			'ReorderRooms',
			{ order = {r1,r2,r3,r4}}
		)
	end

    -- clear or keep every event that has the same type as any event in eventtypes
    function level:clearevents(eventtypes, keeplisted)
        keeplisted = keeplisted or false
        local newevents = {}
        for eventi, event in ipairs(self.data.events) do
            local listedfound = false
            for typei, typev in ipairs(eventtypes) do
                if event.type == typev then
                    listedfound = true
                end
            end
            if listedfound == keeplisted then
                table.insert(newevents, event)
            end
        end
        self.data.events = newevents
    end

    -- shorthand for level:clearevents(eventtypes, true)
    function level:keepevents(eventtypes)
        self:clearevents(eventtypes, true)
    end

    -- border every row
    function level:allborder(beat, bordertype, color, opacity, duration, ease)
        for i, v in ipairs(self.rows) do
            v:setborder(beat, bordertype, color, opacity, duration, ease)
        end
    end

    -- tint every row
    function level:alltint(beat, showtint, color, opacity, duration, ease)
        for i, v in ipairs(self.rows) do
            v:settint(beat, showtint, color, opacity, duration, ease)
        end
    end

    function level:allglow(beat, color, opacity, duration, ease)
        beat = beat or 0
        self:allborder(beat, "Glow", color, opacity, duration, ease)
    end

    function level:alloutline(beat, color, opacity, duration, ease)
        beat = beat or 0
        self:allborder(beat, "Outline", color, opacity, duration, ease)
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

    -- wrap single room number in a table
    function level:roomtable(room)
        local rtable = nil
        if type(room) == "number" then
            rtable = {room}
        else
            rtable = room
        end
        return rtable
    end

    -- set a theme
    function level:settheme(beat, room, theme)
        self.rooms[room]:settheme(beat, theme)
        --self:addevent(beat,'SetTheme',{preset = theme, rooms = self:roomtable(rooms)})
    end

	-- add a custom flash event
	
	function level:customflash(beat,room,startcolor,startopacity,endcolor,endopacity,duration,ease,bg)
		endcolor = endcolor or startcolor
		endopacity = endopacity or startopacity
		duration = duration or 0
		bg = bg or false
		ease = ease or 'Linear'
		self:addevent(beat,'CustomFlash', {rooms = self:roomtable(room), background = bg, duration = duration, startColor = startcolor, startOpacity = startopacity, endColor = endcolor, endOpacity = endopacity, ease = ease})
	end
	
	function level:ontopflash(beat,startcolor,startopacity,endcolor,endopacity,duration,ease,bg)
		self:customflash(beat,4,startcolor,startopacity,endcolor,endopacity,duration,ease,bg)
	end
	
	--screen tile
	function level:screentile(beat,room,x,y)
		local enable = true
		if x == 1 and y == 1 then
			enable = false
		end
		self:addevent(beat,'SetVFXPreset',{rooms = self:roomtable(room), preset = 'TileN', enable = enable, floatX = x, floatY = y})
	end
	
	function level:ontopscreentile(beat,x,y)
		self:screentile(beat,4,x,y)
	end
	
	--screen scroll
	function level:screenscroll(beat,room,x,y)
		local enable = true
		if x == 0 and y == 0 then
			enable = false
		end
		self:addevent(beat,'SetVFXPreset',{rooms = self:roomtable(room), preset = 'CustomScreenScroll', enable = enable, floatX = x, floatY = y})
	end
	
	function level:ontopscreenscroll(beat,x,y)
		self:screenscroll(beat,4,x,y)
	end
	
	--pulse camera
	function level:pulsecamera(beat,room,count,frequency,strength)
		frequency = frequency or 1
		strength = strength or 1
		self:addevent(beat,'PulseCamera',{rooms = self:roomtable(room), strength = strength, count = count, frequency = frequency})
	end
	
	function level:ontoppulsecamera(beat,count,frequency,strength)
		self:pulsecamera(beat,4,count,frequency,strength)
	end
	
	
	
	
	--end level
	function level:finish(beat,delay)
		delay = delay or 0
		for i=0,2 do
			self:addevent(beat+i*delay,'FinishLevel')
		end
	end
	
	
    -- add an arbitrary event
    function level:addevent(beat, event, params)
        local newevent = {}
		beat = beat + self.eos
        newevent.bar, newevent.beat = self:getbm(beat)
        newevent.type = event
		params = params or {}
        params.y = params.y or 0
        for k, v in pairs(params) do
            newevent[k] = v
        end

        table.insert(self.data.events, newevent)
    end
	


    -- save level to file, and resolve fake events
	
	function level:makereal(v)
		if v.type == "updatetint" then
			---------------row movement-----------------------
			self:addevent(
				v.beat,
				"TintRows",
				{
					row = v.row,
					border = getvalue(self.rows[v.row], "border", v.beat),
					borderColor = getvalue(self.rows[v.row], "bordercolor", v.beat),
					borderOpacity = getvalue(self.rows[v.row], "borderopacity", v.beat),
					tint = getvalue(self.rows[v.row], "tint", v.beat),
					tintColor = getvalue(self.rows[v.row], "tintcolor", v.beat),
					tintOpacity = getvalue(self.rows[v.row], "tintopacity", v.beat),
					duration = v.duration,
					ease = v.ease
				}
			)
		elseif v.type == "updaterowx" then
			
			self:addevent(
				v.beat,
				"MoveRow",
				{
					row = v.row,
					target = "WholeRow",
					customPosition = true,
					rowPosition = {
						getvalue(self.rows[v.row], "x", v.beat) +
							getvalue(self.rows[v.row], "room", v.beat) * 852.2727,
						null
					},
					duration = v.duration,
					ease = v.ease
				}
			)
		elseif v.type == "updaterowy" then
			self:addevent(
				v.beat,
				"MoveRow",
				{
					row = v.row,
					target = "WholeRow",
					customPosition = true,
					rowPosition = {
						null,
						getvalue(self.rows[v.row], "y", v.beat)
					},
					duration = v.duration,
					ease = v.ease
				}
			)
		elseif v.type == "updaterowrot" then
			self:addevent(
				v.beat,
				"MoveRow",
				{
					row = v.row,
					target = "WholeRow",
					customPosition = true,
					angle = getvalue(self.rows[v.row], "rot", v.beat),
					duration = v.duration,
					ease = v.ease
				}
			)
		elseif v.type == "updaterowpivot" then
			
			self:addevent(
				v.beat,
				"MoveRow",
				{
					row = v.row,
					target = "WholeRow",
					customPosition = true,
					pivot = getvalue(self.rows[v.row], "pivot", v.beat),
					duration = v.duration,
					ease = v.ease
				}
			)
		----------------------room movement----------------
		elseif v.type == "updateroomx" then
			self:addevent(
				v.beat,
				"MoveRoom",
				{
					y = v.room,
					roomPosition = {
						getvalue(self.rooms[v.room], "x", v.beat),
						null
					},
					duration = v.duration,
					ease = v.ease
				}
			)
		elseif v.type == "updateroomy" then
			self:addevent(
				v.beat,
				"MoveRoom",
				{
					y = v.room,
					roomPosition = {
						null,
						getvalue(self.rooms[v.room], "y", v.beat)
					},
					duration = v.duration,
					ease = v.ease
				}
			)
		elseif v.type == "updateroomscale" then -- room scale doesnt support null notation for some reason????????
			self:addevent(
				v.beat,
				"MoveRoom",
				{
					y = v.room,
					scale = {
						getvalue(self.rooms[v.room], "sx", v.beat),
						getvalue(self.rooms[v.room], "sy", v.beat)
					},
					duration = v.duration,
					ease = v.ease
				}
			)
		elseif v.type == "updateroompivot" then -- same with pivot
			self:addevent(
				v.beat,
				"MoveRoom",
				{
					y = v.room,
					pivot = {
						getvalue(self.rooms[v.room], "px", v.beat),
						getvalue(self.rooms[v.room], "py", v.beat)
					},
					duration = v.duration,
					ease = v.ease
				}
			)
		elseif v.type == "updateroommode" then
			local rmode = "Center"
			if getvalue(self.rooms[v.room], "stretch", v.beat) then
				rmode = "AspectFill"
			end
			self:addevent(
				v.beat,
				"SetRoomContentMode",
				{
					y = v.room,
					mode = rmode
				}
			)
		elseif v.type == "updateroomflip" then
			self:addevent(
				v.beat,
				"FlipScreen",
				{
					rooms = self:roomtable(v.room),
					flipX = getvalue(self.rooms[v.room], "xflip", v.beat),
					flipY = getvalue(self.rooms[v.room], "yflip", v.beat)
				}
			)
		------------------------cameras
		elseif v.type == "updatecamx" then
			self:addevent(
				v.beat,
				"MoveCamera",
				{
					rooms = self:roomtable(v.room),
					cameraPosition = {
						getvalue(self.rooms[v.room], "camx", v.beat),
						null
						
					},
					duration = v.duration,
					ease = v.ease
				}
			)
		elseif v.type == "updatecamy" then
			self:addevent(
				v.beat,
				"MoveCamera",
				{
					rooms = self:roomtable(v.room),
					cameraPosition = {
						null,
						getvalue(self.rooms[v.room], "camy", v.beat)
						
					},
					duration = v.duration,
					ease = v.ease
				}
			)
		elseif v.type == "updatecamzoom" then
			self:addevent(
				v.beat,
				"MoveCamera",
				{
					rooms = self:roomtable(v.room),
					zoom = getvalue(self.rooms[v.room], "camzoom", v.beat),
					duration = v.duration,
					ease = v.ease
				}
			)
		elseif v.type == "updatecamrot" then
			self:addevent(
				v.beat,
				"MoveCamera",
				{
					rooms = self:roomtable(v.room),
					angle = getvalue(self.rooms[v.room], "camrot", v.beat),
					duration = v.duration,
					ease = v.ease
				}
			)
		
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
