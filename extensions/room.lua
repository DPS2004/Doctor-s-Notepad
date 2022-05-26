local extension = function(_level)
	_level.initqueue.queue(2,function(level,beat) --the number is in what order your extension will be loaded. lower = sooner
		
		--all of the functions you are adding to the level table go up here
		
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
				self.level:addfakeevent(beat, "updatecamxy", {room = index, duration = duration, ease = ease})
			end

			function room:camy(beat, y, duration, ease)
				duration = duration or 0
				ease = ease or "Linear"
				setvalue(self, "camy", beat, y)
				self.level:addfakeevent(beat, "updatecamxy", {room = index, duration = duration, ease = ease})
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


	
		--if you need to initialize anything, do it here.

		
		level.rooms = {}

		for i = 0, 4 do
            local newroom = level:getroom(i)
			if (not beat) and (i ~= 4) then
			
				level:addfakeevent(0, "updateroomx", {room = i, duration = 0, ease = "Linear"})
				level:addfakeevent(0, "updateroomy", {room = i, duration = 0, ease = "Linear"})
				level:addfakeevent(0, "updateroomscale", {room = i, duration = 0, ease = "Linear"})
				level:addfakeevent(0, "updateroommode", {room = i, duration = 0, ease = "Linear"})
			end
        end
		
		
		-- fake event handlers
		
		
		level:fakehandler('updateroomx',function(self,v)
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
		end)
		level:fakehandler('updateroomy',function(self,v)
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
		end)
		level:fakehandler('updateroomscale',function(self,v) -- room scale doesnt support null notation for some reason????????
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
		end)
		level:fakehandler('updateroompivot',function(self,v) -- same with pivot
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
		end)
		level:fakehandler('updateroommode',function(self,v)
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
		end)
		level:fakehandler('updateroomflip',function(self,v)
			self:addevent(
				v.beat,
				"FlipScreen",
				{
					rooms = self:roomtable(v.room),
					flipX = getvalue(self.rooms[v.room], "xflip", v.beat),
					flipY = getvalue(self.rooms[v.room], "yflip", v.beat)
				}
			)
		end)
		
		------------------------cameras
		
		level:fakehandler('updatecamxy',function(self,v)
			self:addevent(
				v.beat,
				"MoveCamera",
				{
					rooms = self:roomtable(v.room),
					cameraPosition = {
						getvalue(self.rooms[v.room], "camx", v.beat),
						getvalue(self.rooms[v.room], "camy", v.beat)
						
					},
					duration = v.duration,
					ease = v.ease
				}
			)
		end)
		level:fakehandler('updatecamzoom',function(self,v)
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
		end)
		level:fakehandler('updatecamrot',function(self,v)
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
		end)
		
		--add event type condensers
		
		level:condenser('MoveRoom',function(self,elist)
			local condensed = {}
			local groups = self:getcondensable(elist,{
				'y',
				'duration',
				'ease'
			})
			for i,v in ipairs(groups) do
				table.insert(condensed,self:mergegroup(v))
			end
			return condensed
		end)
		
		
		
	end)
end

return extension