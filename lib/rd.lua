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

    function level:init()
        for i, v in ipairs(self.data.rows) do
            local oldroom = v.rooms[1]

            v.rooms = self:roomtable(0)
            local newrow = self:getrow(v.row)

            setvalue(newrow, "room", 0, oldroom)
            self:addfakeevent(0, "updaterowx", {row = v.row, duration = 0, ease = "Linear"})
            self:addfakeevent(0, "updaterowy", {row = v.row, duration = 0, ease = "Linear"})
            self:addfakeevent(0, "updaterowpivot", {row = v.row, duration = 0, ease = "Linear"})
        end
        for i = 0, 3 do
            local newroom = self:getroom(i)
            self:addfakeevent(0, "updateroomx", {room = i, duration = 0, ease = "Linear"})
            self:addfakeevent(0, "updateroomy", {room = i, duration = 0, ease = "Linear"})
            self:addfakeevent(0, "updateroomscale", {room = i, duration = 0, ease = "Linear"})
            self:addfakeevent(0, "updateroommode", {room = i, duration = 0, ease = "Linear"})
        end
    end

    function level:offset(eos)
        self.eos = eos
    end

    -- add fake event, to be turned into a real event upon saving
    function level:addfakeevent(beat, event, params)
        params = params or {}
        local newevent = {}

        newevent.beat = beat + self.eos
        newevent.type = event
        for k, v in pairs(params) do
            newevent[k] = v
        end
        table.insert(self.fakeevents, newevent)
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
            stretch = {{beat = 0, state = true}},
            --boolean presets
            Sepia = {{beat = 0, state = false}},
            VHS = {{beat = 0, state = false}},
            --other presets
            abberation = {{beat = 0, state = false}},
            abberationintensity = {{beat = 0, state = 0}}
        }

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
                end
            end
        end

        -- change content mode
        function room:stretchmode(beat, state)
            state = state or not getvalue(self, "stretch", beat)
            self:addfakeevent(0, "updateroommode", {room = index})
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

    function level:rdcode(beat, code)
        beat = beat or 0
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
	
	function level:customflash(beat,room)
	
	end

    -- add an arbitrary event
    function level:addevent(beat, event, params)
        local newevent = {}
		beat = beat + self.eos
        newevent.bar, newevent.beat = self:getbm(beat)
        newevent.type = event

        params.y = params.y or 0
        for k, v in pairs(params) do
            newevent[k] = v
        end

        table.insert(self.data.events, newevent)
    end


    -- save level to file, and resolve fake events
    function level:save(filename)
		self.eos = 0
        for i, v in ipairs(self.fakeevents) do
            if v.type == "updatetint" then
                ---------------row movement-----------------------
                self:addevent(
                    v.beat,
                    "TintRows",
                    {
                        row = v.row,
                        border = getvalue(level.rows[v.row], "border", v.beat),
                        borderColor = getvalue(level.rows[v.row], "bordercolor", v.beat),
                        borderOpacity = getvalue(level.rows[v.row], "borderopacity", v.beat),
                        tint = getvalue(level.rows[v.row], "tint", v.beat),
                        tintColor = getvalue(level.rows[v.row], "tintcolor", v.beat),
                        tintOpacity = getvalue(level.rows[v.row], "tintopacity", v.beat),
                        duration = v.duration,
                        ease = v.ease
                    }
                )
            elseif v.type == "updaterowx" then
                print("row: " .. v.row)
                print("final value: " .. getvalue(level.rows[v.row], "room", v.beat))
                self:addevent(
                    v.beat,
                    "MoveRow",
                    {
                        row = v.row,
                        target = "WholeRow",
                        customPosition = true,
                        rowPosition = {
                            getvalue(level.rows[v.row], "x", v.beat) +
                                getvalue(level.rows[v.row], "room", v.beat) * 852.2727,
                            null
                        },
                        duration = v.duration,
                        ease = v.ease
                    }
                )
                print("next!")
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
                            getvalue(level.rows[v.row], "y", v.beat)
                        },
                        duration = v.duration,
                        ease = v.ease
                    }
                )
                print("next!")
			elseif v.type == "updaterowrot" then
                self:addevent(
                    v.beat,
                    "MoveRow",
                    {
                        row = v.row,
                        target = "WholeRow",
                        customPosition = true,
                        angle = getvalue(level.rows[v.row], "rot", v.beat),
                        duration = v.duration,
                        ease = v.ease
                    }
                )
                print("next!")
            elseif v.type == "updaterowpivot" then
                
                self:addevent(
                    v.beat,
                    "MoveRow",
                    {
                        row = v.row,
                        target = "WholeRow",
                        customPosition = true,
                        pivot = getvalue(level.rows[v.row], "pivot", v.beat),
                        duration = v.duration,
                        ease = v.ease
                    }
                )
                print("next!")
			----------------------room movement----------------
            elseif v.type == "updateroomx" then
                self:addevent(
                    v.beat,
                    "MoveRoom",
                    {
                        y = v.room,
                        roomPosition = {
                            getvalue(level.rooms[v.room], "x", v.beat),
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
                            getvalue(level.rooms[v.room], "y", v.beat)
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
                            getvalue(level.rooms[v.room], "sx", v.beat),
                            getvalue(level.rooms[v.room], "sy", v.beat)
                        },
                        duration = v.duration,
                        ease = v.ease
                    }
                )
            elseif v.type == "updateroommode" then
                local rmode = "Center"
                if getvalue(level.rooms[v.room], "stretch", v.beat) then
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
            end
        end

        for i, v in ipairs(self.decorations) do
            v:save()
        end

        dpf.saverdlevel(filename, self.data)
    end

    return level
end

return rd
