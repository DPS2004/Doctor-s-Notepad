local extension = function(_level)
	_level.initqueue.queue(2,function(level,beat) --the number is in what order your extension will be loaded. lower = sooner

		create_enum('textanchor', {'UpperLeft', 'UpperCenter', 'UpperRight', 'MiddleLeft', 'MiddleCenter', 'MiddleRight', 'LowerLeft', 'LowerCenter', 'LowerRight'})
		create_enum('textmode', {'FadeOut', 'HideAbruptly'})
		create_enum('theme', {
			'None', 'Intimate', 'IntimateSimple', 'InsomniacDay', 'InsomniacNight', 'Matrix', 'NeonMuseum', 'CrossesStraight', 'CrossesFalling', 'CubesFalling', 'CubesFallingNiceBlue',
			'OrientalTechno', 'Kaleidoscope', 'PoliticiansRally', 'Rooftop', 'RooftopSummer', 'RooftopAutumn', 'BackAlley', 'Sky', 'NightSky', 'HallOfMirrors', 'CoffeeShop',
			'CoffeeShopNight', 'Garden', 'GardenNight', 'TrainDay', 'TrainNight', 'DesertDay', 'DesertNight', 'HospitalWard', 'HospitalWardNight', 'PaigeOffice', 'Basement',
			'ColeWardNight', 'ColeWardSunrise', 'BoyWard', 'GirlWard', 'Skyline', 'SkylineBlue', 'FloatingHeart', 'FloatingHeartWithCubes', 'FloatingHeartBroken',
			'FloatingHeartBrokenWithCubes', 'ZenGarden', 'Space', 'RollerDisco', 'Vaporwave', 'Stadium', 'StadiumStormy', 'AthleteWard', 'AthleteWardNight', 'ProceduralTree'
		})
		create_enum('handpos', {'Left', 'Right', 'p1', 'p2', 'Both'})
		create_enum('roomcontentmode', {'Center', 'ScaleToFill', 'AspectFill', 'AspectFit', 'Tiled'})
		create_enum('bgtype', {'Color', 'Image'})
		create_enum('bgfilter', {'NearestNeighbor', 'Bilinear'})
		create_enum('bassdropstrength', {'Low', 'Medium', 'High'})
		create_enum('shakestrength', {'Low', 'Medium', 'High'})
		create_enum('textexplosionmode', {'OneColor', 'Random'})
		create_enum('textexplosiondirection', {'Left', 'Right'})
		create_enum('stutteraction', {'Add', 'Cancel'})
		
		--all of the functions you are adding to the level table go up here
		
		-- create room objects from index
		function level:getroom(index)
			if level.rooms[index] then
				return level.rooms[index]
			end

			local room = {}
			room.objecttype = 'room'
			room.level = self
			room.index = index
			room.values = {
				x = {{beat = 0, state = 50}},
				y = {{beat = 0, state = 50}},
				sx = {{beat = 0, state = 100}},
				sy = {{beat = 0, state = 100}},
				px = {{beat = 0, state = 50}},
				py = {{beat = 0, state = 50}},
				angle = {{beat = 0, state = 0}},
				stretch = {{beat = 0, state = true}},
				mask = {{beat = 0, state = {''}}},
				bg = {{beat = 0, state = {''}}},
				fg = {{beat = 0, state = {''}}},
				xflip = {{beat = 0, state = false}},
				yflip = {{beat = 0, state = false}},				
				handvis = {{beat = 0, state = false}},
				corners = {{beat = 0, state = { {0, 0}, {100, 0}, {0, 100}, {100, 100} } }},
				opacity = {{beat = 0, state = 100}},
				invert = {{beat = 0, state = false}},
				--camera
				camx = {{beat = 0, state = 50}},
				camy = {{beat = 0, state = 50}},
				camzoom = {{beat = 0, state = 100}},
				camrot = {{beat = 0, state = 0}},
			}
			--move rooms
			function room:movex(beat, x, duration, ease)
				checkvar_type(beat, 'beat', 'number')
				checkvar_type(x, 'x', 'number')
				checkvar_enum(ease, 'ease', enums.ease, true)
				checkvar_type(duration, 'duration', 'number', true)

				duration = duration or 0
				ease = ease or "Linear"
				setvalue(self, "x", beat, x)
				self.level:addfakeevent(beat, "updateroomx", {room = index, duration = duration, ease = ease})
			end

			function room:movey(beat, y, duration, ease)
				checkvar_type(beat, 'beat', 'number')
				checkvar_type(y, 'y', 'number')
				checkvar_enum(ease, 'ease', enums.ease, true)
				checkvar_type(duration, 'duration', 'number', true)

				duration = duration or 0
				ease = ease or "Linear"
				setvalue(self, "y", beat, y)
				self.level:addfakeevent(beat, "updateroomy", {room = index, duration = duration, ease = ease})
			end

			function room:movesx(beat, sx, duration, ease)
				checkvar_type(beat, 'beat', 'number')
				checkvar_type(sx, 'sx', 'number')
				checkvar_enum(ease, 'ease', enums.ease, true)
				checkvar_type(duration, 'duration', 'number', true)

				duration = duration or 0
				ease = ease or "Linear"
				setvalue(self, "sx", beat, sx)
				self.level:addfakeevent(beat, "updateroomscale", {room = index, duration = duration, ease = ease})
			end

			function room:movesy(beat, sy, duration, ease)
				checkvar_type(beat, 'beat', 'number')
				checkvar_type(sy, 'sy', 'number')
				checkvar_enum(ease, 'ease', enums.ease, true)
				checkvar_type(duration, 'duration', 'number', true)

				duration = duration or 0
				ease = ease or "Linear"
				setvalue(self, "sy", beat, sy)
				self.level:addfakeevent(beat, "updateroomscale", {room = index, duration = duration, ease = ease})
				
			end
			
			function room:movepx(beat, px, duration, ease)
				checkvar_type(beat, 'beat', 'number')
				checkvar_type(px, 'px', 'number')
				checkvar_enum(ease, 'ease', enums.ease, true)
				checkvar_type(duration, 'duration', 'number', true)

				duration = duration or 0
				ease = ease or "Linear"
				setvalue(self, "px", beat, px)
				self.level:addfakeevent(beat, "updateroompivot", {room = index, duration = duration, ease = ease})
			end

			function room:movepy(beat, py, duration, ease)
				checkvar_type(beat, 'beat', 'number')
				checkvar_type(py, 'py', 'number')
				checkvar_enum(ease, 'ease', enums.ease, true)
				checkvar_type(duration, 'duration', 'number', true)

				duration = duration or 0
				ease = ease or "Linear"
				setvalue(self, "py", beat, py)
				self.level:addfakeevent(beat, "updateroompivot", {room = index, duration = duration, ease = ease})
				
			end

			function room:rotate(beat, rot, duration, ease)
				checkvar_type(beat, 'beat', 'number')
				checkvar_type(rot, 'rot', 'number')
				checkvar_enum(ease, 'ease', enums.ease, true)
				checkvar_type(duration, 'duration', 'number', true)

				duration = duration or 0
				ease = ease or "Linear"
				setvalue(self, "angle", beat, rot)
				self.level:addfakeevent(beat, "updateroomangle", {room = index, duration = duration, ease = ease})
			end
			
			

			function room:move(beat, p, duration, ease)
				checkvar_type(beat, 'beat', 'number')
				checkvar_type(p, 'p', 'table')
				checkvar_enum(ease, 'ease', enums.ease, true)
				checkvar_type(duration, 'duration', 'number', true)

				duration = duration or 0
				ease = ease or "Linear"
				for k, v in pairs(p) do
					if k == "rotate" or k == "rot" then
						self:rotate(beat, v, duration, ease)
					else
						-- copied this from row.lua lmao but should still work
						local func = 'move'..k

						if self[func] then
							self[func](self, beat, v, duration, ease) -- dont think you can use : with this method though so gotta pass in self for the first variable
						end
					end
				end
			end
			
			--move cams
			function room:camx(beat, x, duration, ease)
				checkvar_type(beat, 'beat', 'number')
				checkvar_type(x, 'x', 'number')
				checkvar_enum(ease, 'ease', enums.ease, true)
				checkvar_type(duration, 'duration', 'number', true)

				duration = duration or 0
				ease = ease or "Linear"
				setvalue(self, "camx", beat, x)
				self.level:addfakeevent(beat, "updatecamx", {room = index, duration = duration, ease = ease})
			end

			function room:camy(beat, y, duration, ease)
				checkvar_type(beat, 'beat', 'number')
				checkvar_type(y, 'y', 'number')
				checkvar_enum(ease, 'ease', enums.ease, true)
				checkvar_type(duration, 'duration', 'number', true)

				duration = duration or 0
				ease = ease or "Linear"
				setvalue(self, "camy", beat, y)
				self.level:addfakeevent(beat, "updatecamy", {room = index, duration = duration, ease = ease})
			end

			function room:camzoom(beat, z, duration, ease)
				checkvar_type(beat, 'beat', 'number')
				checkvar_type(z, 'z', 'number')
				checkvar_enum(ease, 'ease', enums.ease, true)
				checkvar_type(duration, 'duration', 'number', true)

				duration = duration or 0
				ease = ease or "Linear"
				setvalue(self, "camzoom", beat, z)
				self.level:addfakeevent(beat, "updatecamzoom", {room = index, duration = duration, ease = ease})
			end
			function room:camrot(beat, z, duration, ease)
				checkvar_type(beat, 'beat', 'number')
				checkvar_type(z, 'z', 'number')
				checkvar_enum(ease, 'ease', enums.ease, true)
				checkvar_type(duration, 'duration', 'number', true)

				duration = duration or 0
				ease = ease or "Linear"
				setvalue(self, "camrot", beat, z)
				self.level:addfakeevent(beat, "updatecamrot", {room = index, duration = duration, ease = ease})
			end
			
			function room:cam(beat, p, duration, ease)
				checkvar_type(beat, 'beat', 'number')
				checkvar_type(p, 'p', 'table')
				checkvar_enum(ease, 'ease', enums.ease, true)
				checkvar_type(duration, 'duration', 'number', true)

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
				checkvar_type(beat, 'beat', 'number')
				checkvar_type(state, 'state', 'boolean', true)

				if type(state) ~= 'boolean' then
					state = not getvalue(self, "xflip", beat)
				end
				setvalue(self,'xflip',beat,state)
				self.level:addfakeevent(beat,'updateroomflip', {room = index})
			end
			
			function room:yflip(beat,state)
				checkvar_type(beat, 'beat', 'number')
				checkvar_type(state, 'state', 'boolean', true)

				if type(state) ~= 'boolean' then
					state = not getvalue(self, "yflip", beat)
				end
				setvalue(self,'yflip',beat,state)
				self.level:addfakeevent(beat,'updateroomflip', {room = index})
			end

			-- change content mode
			function room:stretchmode(beat, state)
				checkvar_type(beat, 'beat', 'number')
				checkvar_type(state, 'state', 'boolean', true)

				if type(state) ~= 'boolean' then
					state = not getvalue(self, "stretch", beat)
				end
				setvalue(self,'stretch',beat, state)
				self.level:addfakeevent(beat, "updateroommode", {room = index})
			end

			-- mask
			function room:mask(beat, filenames, fps)
				checkvar_type(beat, 'beat', 'number')
				checkvar_type(fps, 'fps', 'number')

				filenames = filenames or ''
				fps = fps or 30

				if type(filenames) ~= 'table' then
					filenames = {tostring(filenames)}
				end

				setvalue(self, 'mask', beat, filenames)

				self.level:addevent(beat, "MaskRoom", {image = filenames, fps = fps, y = index, contentMode = 'ScaleToFill'})

			end

			-- perspective
			function room:setperspective(beat, pos, duration, ease)
				checkvar_type(beat, 'beat', 'number')
				checkvar_type(duration, 'duration', 'number', true)
				checkvar_enum(ease, 'ease', enums.ease, true)

				local newcorners = {}

				duration = duration or 0
				ease = ease or 'Linear'

				if type(pos) ~= 'table' then
					pos = {}
				end

				for i=1,4 do

					pos[i] = pos[i] or {}

					newcorners[#newcorners+1] = {pos[i][1], pos[i][2]}

					pos[i][1] = pos[i][1] or null
					pos[i][2] = pos[i][2] or null

				end

				setvalue(self, 'corners', beat, newcorners)

				self.level:addfakeevent(beat, 'updateroomperspective', {room = index, corners = pos, duration = duration, ease = ease})

			end

			-- text
			-- the times here is just a table with offsets from the base 'beat' variable for each AdvanceText event
			-- i.e. if beat is 3 and times is {1} then there will be the floating text event at beat 3 and an Advance Text event at beat 4 (3+1)
			function room:floatingtext(beat, text, times, x, y, size, angle, mode, showChildren, color, outlineColor, anchor, fadeOutRate)
				checkvar_type(beat, 'beat', 'number')
				checkvar_type(text, 'text', 'number')
				checkvar_type(times, 'times', 'table', true)
				checkvar_type(x, 'x', 'number', true)
				checkvar_type(y, 'y', 'number', true)
				checkvar_type(size, 'size', 'number', true)
				checkvar_type(angle, 'angle', 'number', true)
				checkvar_enum(mode, 'mode', enums.textmode, true)
				checkvar_type(showChildren, 'showChildren', 'boolean', true)
				checkvar_type(color, 'color', 'string', true)
				checkvar_type(outlineColor, 'outlineColor', 'string', true)
				checkvar_enum(anchor, 'anchor', enums.textanchor, true)
				checkvar_type(fadeOutRate, 'fadeOutRate', 'number', true)

				x = x or 50
				y = y or 50
				times = times or {}
				size = size or 8
				angle = angle or 0
				mode = mode or 'FadeOut'
				if showChildren == nil then showChildren = true end -- 'showChildren = showChildren or true' will NOT work for this because if showChildren is false then it will just be set to true!
				color = color or 'ffffffff'
				outlineColor = outlineColor or '000000ff'
				anchor = anchor or 'MiddleCenter'
				fadeOutRate = fadeOutRate or 3

				self.level:addevent(beat, "FloatingText",{ -- the floating text has so many options :notlikeshift:
					rooms = self.level:roomtable(index),
					id = level.floatingtextid,
					text = text,
					times = '',
					textPosition = {x, y},
					size = size,
					angle = angle,
					mode = mode,
					showChildren = showChildren,
					color = color,
					outlineColor = outlineColor,
					anchor = anchor,
					fadeOutRate = fadeOutRate
				})

				for _,t in ipairs(times) do

					t = tonumber(t)

					if t then
						self.level:addevent(beat + t, 'AdvanceText', {id = level.floatingtextid})
					end

				end

				level.floatingtextid = level.floatingtextid + 1

			end

			-- set theme
			function room:settheme(beat, theme)
				checkvar_type(beat, 'beat', 'number')
				checkvar_enum(theme, 'theme', enums.theme)
				self.level:addevent(beat, "SetTheme", {rooms = self.level:roomtable(index), preset = theme})
			end

			-- haha        lmao
			-- generate all the preset values    haha            lmao

			-- lookup table automatically filled with the aliases as keys and actual preset names as values
			local aliasToPreset = {}

			-- the only reason this is in a do-end block is so that its easier to tell where it starts and ends.        yeah
			-- well also it makes it easier to collapse the whole thing haha
			do

				-- key in the table = actual name written in the rdlevel
				-- each preset has a table with additional properties like intensity
				-- along the elements in the table a true/false value will be automatically created for each preset
				-- properties with the _ prefix are not counted as actual properties of the event!
				-- properties may, additionally, be a table:
					-- the first element of the table is the actual value
					-- the second is the order of the property in the function
					-- the third is an optional type of the property: if omitted, will default to 'number'
				-- the order is used because pairs() is random :( so you never know in what order the parameters will be. the order fixes this by ordering the table using it
				local roomPresets = {
					Sepia = {_onTop = true},
					VHS = {},
					SilhouettesOnHBeat = {},
					Vignette = {},
					VignetteFlicker = {},
					ColourfulShockwaves = {},
					BassDropOnHit = {},
					ShakeOnHeartBeat = {},
					ShakeOnHit = {},
					Tile2 = {_onTop = true},
					Tile3 = {_onTop = true},
					Tile4 = {_onTop = true},
					LightStripVert = {},
					ScreenScrollX = {},
					ScreenScroll = {_alias = 'screenscrolly'},
					RowGlowWhite = {},
					RowOutline = {},
					RowSilhouetteGlow = {},
					RowShadow = {},
					RowAllWhite = {},
					RowPlain = {},
					ScreenScrollXSansVHS = {},
					ScreenScrollSansVHS = {_alias = 'screenscrollysansvhs'},
					CutsceneMode = {_alias = 'cutscene'},
					Blackout = {},
					Noise = {_onTop = true},
					GlitchObstruction = {_onTop = true},
					Matrix = {},
					Confetti = {},
					FallingPetals = {},
					FallingPetalsInstant = {},
					FallingPetalsSnow = {},
					Snow = {},
					OrangeBloom = {},
					BlueBloom = {},
					HallOfMirrors = {_alias = {'hom', 'hallofmirrors'}, _onTop = true},
					BlackAndWhite = {_alias = {'grayscale', 'blackandwhite'}, _onTop = true},
					NumbersAbovePulses = {},
					Funk = {},
					Rain = {intensity = 100},
					Grain = {intensity = 100},
					Mosaic = {intensity = 100},
					Bloom = {threshold = {0.3, 0}, intensity = {2, 1}, color = {'000000', 2, 'color'}},
					ScreenWaves = {intensity = 100},
					Drawing = {intensity = 100},
					JPEG = {intensity = 100},
					TileN = {floatX = {1, 0}, floatY = {1, 1}, _alias = {'tilen', 'screentile'}, _onTop = true},
					CustomScreenScroll = {floatX = {1, 0}, floatY = {1, 1}, _alias = {'screenscroll', 'customscreenscroll'}, _onTop = true},
					Aberration = {intensity = 100},
					Blizzard = {intensity = 100},
					Blur = {intensity = 100},
					RadialBlur = {intensity = 100},
					HueShift = {intensity = 100},
					WavyRows = {amplitude = {15, 0}, frequency = {2, 1}, _customFunc = function()
						local s = 'if amplitude then level:comment(beat, "()=>wavyRowsAmplitude(" .. index .. ", " .. amplitude .. ", " .. duration .. ")") end\n'
						s = s .. 'if frequency then level:rdcode(beat, "room[" .. index .. "].wavyRowsFrequency = " .. frequency, "OnBar") end\n'
						return s
					end},
					Brightness = {intensity = 100, _onTop = true},
					Contrast = {intensity = 100, _onTop = true},
					Saturation = {intensity = 100, _onTop = true},
					Dots = {intensity = 100, _alias = {'dots', 'dotmatrix'}}
				}

				for k,v in pairs(roomPresets) do

					local cancontinue = false -- can we actually use this preset?

					if index ~= 4 then
						cancontinue = true -- if we aren't on the ontop camera, go ahead
					else -- we are on the ontop camera
						cancontinue = v._onTop -- if we have a _onTop value for this property, go ahead. if not, this is not a preset for the ontop camera so we dont do anything with it
					end
					
					if cancontinue then

						local lowercasekey = k:lower()

						-- make _alias into table
						if type(v._alias) ~= 'table' then
							v._alias = {v._alias}
						end

						-- if we dont have any aliases, we just add the current name to the table
						if #v._alias < 1 then v._alias[1] = lowercasekey end

						local additionalProperties = {} -- store stuff such as intensity as a string here for simpler later use

						-- add everything to the values table

						room.values[lowercasekey] = {{beat = 0, state = {enable = false}}}

						for k2,v2 in pairs(v) do

							if k2:sub(1,1) ~= '_' then -- exclude properties that have the _ prefix

								local lowercase2 = lowercasekey .. k2:lower()

								if type(v2) ~= 'table' then v2 = {v2, #additionalProperties} end

								room.values[lowercasekey][1].state[k2] = v2[1]

								additionalProperties[#additionalProperties+1] = {k2, v2[2]}

								v[k2] = v2

							end

						end

						table.sort(additionalProperties, function(a,b)
							return a[2] < b[2]
						end) -- sort by order

						for i,_ in ipairs(additionalProperties) do
							additionalProperties[i] = additionalProperties[i][1]
						end

						----------------------------------

						-- save each alias and preset in the aliasToPreset table
						for _,name in ipairs(v._alias) do

							local lowercase = name:lower()

							if lowercase ~= lowercasekey then -- dont save aliases that have the same name as the real preset
								aliasToPreset[lowercase] = lowercasekey
							end

						end

						----------------------------------

						-- now that im recoding this with more lua knowledge lets be smarter

						-- and make a base function in string form
						local functionBase = [[
function room:ALIAS(beat, state, ..., duration, ease)
	checkvar_type(beat, 'beat', 'number', false, 4)
	checkvar_type(state, 'state', 'boolean', false, 4)
	checkvar_type(duration, 'duration', 'number', true, 4)
	checkvar_enum(ease, 'ease', enums.ease, true, 4)

	duration = duration or 0
	ease = ease or 'Linear'

	-- get real name of preset from alias
	local preset = aliasToPreset['ALIAS'] or 'ALIAS'

	-- get current values
	local t = getvalue(self, preset, beat)

	-- if not specified or not a boolean, toggle instead of setting
	if type(state) ~= type(true) then
		state = not t.enable
	end

	-- copy t into new table
	local faket = {}
	local newt = {}
	for k,v in pairs(t) do
		faket[k] = v
		newt[k] = v
	end

	newt.enable = state
	faket.enable = state

	faket.duration = duration
	faket.ease = ease
	faket.preset = preset
	faket.rooms = level:roomtable(index)

	-- handle parameters: ...
	PARAMETERS

	-- customfunc, where applicable
	CUSTOMFUNC

	-- create actual event
	level:addevent(
		beat,
		"SetVFXPreset",
		faket
	)

	setvalue(self, preset, beat, newt)

end]]

						-- create the function

						-- go through every alias and make a function for each

						for _,name in ipairs(v._alias) do

							if #additionalProperties > 0 then -- presets with multiple parameters (more than whether it's enabled)

								local final = functionBase

								final = final:gsub('ALIAS', name)

								-- replace the '...' in the base
								final = final:gsub('%.%.%.', table.concat(additionalProperties, ', '))

								-- generate 'PARAM = PARAM or DEFAULT' text
								local paramt = {}
								for _, param in ipairs(additionalProperties) do
									if v[param][3] == 'color' then -- whatever
										paramt[#paramt+1] = string.format('checkvar_color(%s, "%s", true, 4)', param, param)
									else
										paramt[#paramt+1] = string.format('checkvar_type(%s, "%s", "%s", true, 4)', param, param, v[param][3] or 'number')
									end
									paramt[#paramt+1] = string.format('faket.%s = %s or %s', param, param, v[param][1])
									paramt[#paramt+1] = string.format('newt.%s = %s or %s', param, param, v[param][1])
								end

								final = final:gsub('PARAMETERS', table.concat(paramt, '\n\t'))

								-- _customFunc support
								if v._customFunc then

									local s = v._customFunc()
									final = final:gsub('CUSTOMFUNC', s)

								else

									final = final:gsub('CUSTOMFUNC', '')

								end

								f = loadstring(final) -- haha lmao

								local env = {level = level, room = room, index = index, getvalue = getvalue, setvalue = setvalue, type = type, print = print, aliasToPreset = aliasToPreset, pairs = pairs, checkvar_type = checkvar_type, checkvar_enum = checkvar_enum, checkvar_color = checkvar_color, enums = enums}
								setfenv(f, env)   --   haha      lmao
								
								f()                 --                                haha                                         lmao

								-- level:ontop, where applicable
								if v._onTop then
									level['ontop' .. name] = function(level, ...)
										level:getroom(4)[name](level:getroom(4), ...)
									end
								end

							else -- one parameter, objectively easier

								room[name] = function(room, beat, state)
									room:setpreset(beat, aliasToPreset[name] or name, state)
								end

								if v._onTop then
									level['ontop' .. name] = function(level, beat, state)
										level:getroom(4):setpreset(beat, aliasToPreset[name] or name, state)
									end
								end

							end

						end

					end

				end

			end

			-- set or toggle a boolean vfx preset
			function room:setpreset(beat, preset, state)
				checkvar_type(beat, 'beat', 'number')
				checkvar_type(preset, 'preset', 'string')
				checkvar_type(state, 'state', 'boolean')

				preset = tostring(preset):lower()
				preset = aliasToPreset[preset] or preset -- allow for stuff like room:setpreset(beat, 'screentile', true) even though the preset is actually 'tilen'

				local t = getvalue(self, preset, beat)

				if type(state) ~= type(true) then
					state = not t.enable
				end

				local newt = {}
				local faket = {}

				for k,v in pairs(t) do
					newt[k] = v
					faket[k] = v
				end

				newt.enable = state
				faket.enable = state

				setvalue(self, preset, beat, newt)

				faket.preset = preset
				faket.rooms = level:roomtable(room.index)

				self.level:addevent(
					beat,
					"SetVFXPreset",
					faket
				)
			end

			-- get the state of a preset or of a preset's property
			function room:getpreset(beat, preset, property)
				checkvar_type(beat, 'beat', 'number')
				checkvar_type(preset, 'preset', 'string')
				checkvar_type(property, 'property', 'string', true)

				preset = tostring(preset):lower()
				preset = aliasToPreset[preset] or preset -- allow for stuff like room:getpreset(beat, 'screentile') even though the preset is actually 'tilen'
				-- :)

				local t = getvalue(self, preset, beat)

				if t then

					local faket = {}

					for k,v in pairs(t) do
						faket[k:lower()] = v
					end

					if not property then
						return faket.enable
					else
						return faket[property:lower()]
					end

				end

			end
			
			function room:flash(beat,startcolor,startopacity,endcolor,endopacity,duration,ease,bg)
				checkvar_type(beat, 'beat', 'number')
				checkvar_color(startcolor, 'startcolor', 'string', true)
				checkvar_type(startopacity, 'startopacity', 'number', true)
				checkvar_color(endcolor, 'endcolor', 'string', true)
				checkvar_type(endopacity, 'endopacity', 'number', true)
				checkvar_type(duration, 'duration', 'number', true)
				checkvar_enum(ease, 'ease', enums.ease, true)
				checkvar_type(bg, 'bg', 'boolean', true)

				startcolor = startcolor or 'ffffff'
				startopacity = startopacity or 100
				endcolor = endcolor or startcolor
				endopacity = endopacity or startopacity
				duration = duration or 0
				bg = bg or false
				ease = ease or 'Linear'

				self.level:addevent(beat,'CustomFlash', {rooms = self.level:roomtable(room), background = bg, duration = duration, startColor = startcolor, startOpacity = startopacity, endColor = endcolor, endOpacity = endopacity, ease = ease})
			end

			function room:pulsecamera(beat, count, frequency, strength)
				checkvar_type(beat, 'beat', 'number')
				checkvar_type(count, 'count', 'number', true)
				checkvar_type(frequency, 'frequency', 'number', true)
				checkvar_type(strength, 'strength', 'number', true)

				count = count or 1
				frequency = frequency or 1
				strength = strength or 1

				self.level:addevent(beat, 'PulseCamera', {rooms = self.level:roomtable(index), strength = strength, count = count, frequency = frequency})
			end
			
			--hands
			function room:showhand(beat,hand,instant,align)
				checkvar_type(beat, 'beat', 'number')
				checkvar_enum(hand, 'hand', enums.handpos, true)
				checkvar_type(instant, 'instant', 'boolean', true)
				checkvar_type(align, 'align', 'boolean', true)

				hand = hand or 'Right'
				instant = instant or false
				if align == nil then align = true end
				
				setvalue(self, "handvis", beat, true)
				
				self.level:addfakeevent(beat, 'updatehands', {room = index, action = 'Show',instant = instant, align = align, hand = hand})
				
			end
			function room:hidehand(beat,hand,instant,align)
				checkvar_type(beat, 'beat', 'number')
				checkvar_enum(hand, 'hand', enums.handpos, true)
				checkvar_type(instant, 'instant', 'boolean', true)
				checkvar_type(align, 'align', 'boolean', true)

				hand = hand or 'Right'
				instant = instant or false
				if align == nil then align = true end
				
				setvalue(self, "handvis", beat, false)
				
				self.level:addfakeevent(beat, 'updatehands', {room = index, action = 'hide',instant = instant, align = align, hand = hand})
				
			end
			
			function room:togglehand(beat,hand,instant,align)
				checkvar_type(beat, 'beat', 'number')
				checkvar_enum(hand, 'hand', enums.handpos, true)
				checkvar_type(instant, 'instant', 'boolean', true)
				checkvar_type(align, 'align', 'boolean', true)

				if getvalue(self, "handvis", beat) then
					self:hidehand(beat,hand,instant,align)
				else
					self:showhand(beat,hand,instant,align)
				end
				
			end
			
			
			-- background
			function room:setbg(beat,filenames,bgtype,fps,mode,sx,sy,color,filter,duration,ease)
				checkvar_type(beat, 'beat', 'number')
				checkvar_enum(bgtype, 'bgtype', enums.bgtype, true)
				checkvar_enum(filter, 'filter', enums.bgfilter, true)
				checkvar_type(fps, 'fps', 'number', true)
				checkvar_enum(mode, 'mode', enums.roomcontentmode, true)
				checkvar_type(sx, 'sx', 'number', true)
				checkvar_type(sy, 'sy', 'number', true)
				checkvar_color(color, 'color')
				checkvar_type(duration, 'duration', 'number', true)
				checkvar_enum(ease, 'ease', enums.ease, true)

				mode = mode or 'ScaleToFill'
				sx = sx or 0
				sy = sy or 0
				color = color or 'ffffffff'
				fps = fps or 30
				bgtype = bgtype or 'Image'
				filter = filter or 'NearestNeighbor'
				
				duration = duration or 0
				ease = ease or 'Linear'

				if type(filenames) ~= 'table' then
					filenames = {tostring(filenames)}
				end

				setvalue(self, 'bg', beat, filenames)

				self.level:addevent(
					beat,
					"SetBackgroundColor", -- why the :politician: is it called background color if it also sets the image 🤨
					{
						rooms = self.level:roomtable(index),
						backgroundType = bgtype,
						contentMode = mode,
						color = color,
						image = filenames,
						fps = fps,
						filter = filter,
						scrollX = sx,
						scrollY = sy,
						duration = duration,
						ease = ease
					}
				)
			end

			-- foreground
			function room:setfg(beat,filenames,fps,mode,sx,sy,color,duration,ease)
				checkvar_type(beat, 'beat', 'number')
				checkvar_type(fps, 'fps', 'number', true)
				checkvar_enum(mode, 'mode', enums.roomcontentmode, true)
				checkvar_type(sx, 'sx', 'number', true)
				checkvar_type(sy, 'sy', 'number', true)
				checkvar_color(color, 'color')
				checkvar_type(duration, 'duration', 'number', true)
				checkvar_enum(ease, 'ease', enums.ease, true)

				mode = mode or 'ScaleToFill'
				sx = sx or 0
				sy = sy or 0
				color = color or 'ffffffff'
				fps = fps or 30
				duration = duration or 0
				ease = ease or "Linear"

				if type(filenames) ~= 'table' then
					filenames = {tostring(filenames)}
				end

				setvalue(self, 'fg', beat, filenames)

				self.level:addevent(
					beat,
					"SetForeground",
					{
						rooms = self.level:roomtable(index),
						contentMode = mode,
						color = color,
						image = filenames,
						fps = fps,
						scrollX = sx,
						scrollY = sy,
						duration = duration,
						ease = ease
					}
				)
			end

			-- fade (this is the last function im commenting)
			function room:fade(beat,opacity,duration,ease)
				checkvar_type(beat, 'beat', 'number')
				checkvar_type(opacity, 'opacity', 'number')
				checkvar_type(duration, 'duration', 'number', true)
				checkvar_enum(ease, 'ease', enums.ease, true)

				opacity = opacity or 100
				duration = duration or 0
				ease = ease or 'Linear'

				setvalue(self, 'opacity', beat, opacity)

				self.level:addevent(
					beat,
					'FadeRoom',
					{
						y = index,
						opacity = opacity,
						duration = duration,
						ease = ease
					}
				)

			end
			function room:bassdrop(beat, strength)
				checkvar_type(beat, 'beat', 'number')
				checkvar_enum(strength, 'strength', enums.bassdropstrength, true)

				strength = strength or 'Low'

				self.level:addevent(
					beat,
					'BassDrop',
					{
						rooms = self.level:roomtable(index),
						strength = strength
					}
				)

			end

			function room:shake(beat, shakelevel)
				checkvar_type(beat, 'beat', 'number')
				checkvar_enum(shakelevel, 'shakelevel', enums.shakestrength, true)

				shakelevel = shakelevel or 'Low'

				self.level:addevent(
					beat,
					'ShakeScreen',
					{
						rooms = self.level:roomtable(index),
						shakeLevel = shakelevel
					}
				)

			end

			function room:invertcolors(beat, state)
				checkvar_type(beat, 'beat', 'number')
				checkvar_type(state, 'state', 'boolean', true)

				if state == nil then
					state = not getvalue(self, 'invert', beat)
				end

				setvalue(self, 'invert', beat, state)

				self.level:addevent(
					beat,
					'InvertColors',
					{
						rooms = self.level:roomtable(index),
						enable = state
					}
				)

			end

			function room:textexplosion(beat, text, color, mode, direction)
				checkvar_type(beat, 'beat', 'number')
				checkvar_type(text, 'text', 'string', true)
				checkvar_color(color, 'color')
				checkvar_enum(mode, 'mode', enums.textexplosionmode, true)
				checkvar_enum(direction, 'direction', enums.textexplosiondirection, true)

				text = text or ''
				color = color or '000000'
				mode = mode or 'OneColor'
				direction = direction or 'Left'

				self.level:addevent(
					beat,
					'TextExplosion',
					{
						rooms = self.level:roomtable(index),
						text = text,
						color = color,
						mode = mode,
						direction = direction
					}
				)

			end

			function room:stutter(beat, action, sourcebeat, length, loops)
				checkvar_type(beat, 'beat', 'number')
				checkvar_enum(action, 'action', enums.stutteraction, true)
				checkvar_type(sourcebeat, 'sourcebeat', 'number', true)
				checkvar_type(length, 'length', 'number', true)
				checkvar_type(loops, 'loops', 'number', true)

				action = action or 'Add'
				sourcebeat = sourcebeat or 0
				length = length or 0
				loops = loops or 1

				self.level:addevent(
					beat,
					'Stutter',
					{
						rooms = self.level:roomtable(index),
						action = action,
						sourceBeat = sourcebeat,
						length = length,
						loops = loops
					}
				)

			end


			--save to level
			function room:save()
			end

			level.rooms[index] = room

			return room
		end
		
		-- get the version of a room that is needed for your usecase
		function level:parseroom(room,returntable)
			checkvar_type(returntable, 'returntable', 'boolean', true)
			
			if type(room) == 'table' then 
				if room.objecttype == 'room' then
				
					if returntable then
						return room
					else
						return room.index
					end
					
				else
					error('Tried to use an object of type "'..room.objecttype..'" as a room!')
				end
			else
				if room < 0 or room > 4 then
					error('Tried to use a room with an id of '..room)
				end
				
				if returntable then
					return self:getroom(room)
				else
					return room
				end
			end
		
		end
		
		
		function level:setuprooms(beat)
			checkvar_type(beat, 'beat', 'number')

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
					scrollY = 0,
					duration = 0,
					ease = 'Linear'
				}
			)
		end
		
		
		--reorder rooms (find a cleaner solution later)
		function level:reorderrooms(beat,r1,r2,r3,r4)
			checkvar_type(beat, 'beat', 'number')
			checkvar_type(r1, 'r1', 'number')
			checkvar_type(r2, 'r2', 'number')
			checkvar_type(r3, 'r3', 'number')
			checkvar_type(r4, 'r4', 'number')

			self:addevent(
				beat,
				'ReorderRooms',
				{ order = {r1,r2,r3,r4}}
			)
		end

		local function createlevelmethods()
			-- autogenerate all the level: functions using the room: functions if they dont already exist
			-- yes i am doing it like this who needs readability am i right

			local ontopfunctions = { -- list of what functions can be ontop and make another function for that
				setbg = true,
				setfg = true,
				flash = true,
				bassdrop = true,
				shake = true,
				xflip = true,
				yflip = true,
				floatingtext = true,
				camx = true, camy = true, camzoom = true, camrot = true
			}

			local functionblacklist = { -- add functions from room has that the level shouldn't have here
				save = true -- we Absolutely Do Not want to be able to call this from level
			}

			local room = level:getroom(0) -- the only reason i use this is to get all the functions of the rooms

			for k,v in pairs(room) do
				local cancontinue = false -- at first assume we can't continue at all
				if type(v) == 'function' then cancontinue = true end -- if we found a function, we can continue
				if level[k] then cancontinue = false end -- don't make the function if we already have it somehow
				if functionblacklist[k] then cancontinue = false end -- if the function is in the blacklist don't continue

				if cancontinue then

					level[k] = function(self, beat, room, ...) -- vararg my beloved
						local thisroom = self:getroom(room)
						local func = thisroom[k]
						func(thisroom, beat, ...)
					end

					if ontopfunctions[k] then
						level['ontop'..k] = function(self, beat, ...) -- vararg my beloved
							local thisroom = self:getroom(4)
							local func = thisroom[k]
							func(thisroom, beat, ...)
						end
					end

				end
			end

		end
	
		--if you need to initialize anything, do it here.

		
		level.rooms = {}

		if configHandler.getConfigValue("initevents") then

			for i = 0, 4 do
	            local newroom = level:getroom(i)
				if (not beat) and (i ~= 4) then
				
					level:addfakeevent(0, "updateroomx", {room = i, duration = 0, ease = "Linear"})
					level:addfakeevent(0, "updateroomy", {room = i, duration = 0, ease = "Linear"})
					level:addfakeevent(0, "updateroomscale", {room = i, duration = 0, ease = "Linear"})
					level:addfakeevent(0, "updateroommode", {room = i, duration = 0, ease = "Linear"})
				end
	        end

	    end

        -- calling this here since the first room gotta be initialized first
        createlevelmethods()


        local foundtext = false
        level.floatingtextid = 0
        for _,event in ipairs(level.data.events) do
        	if event.type == 'FloatingText' then
        		foundtext = true
        		level.floatingtextid = math.max(level.floatingtextid, event.id)
        	end
        end
        if foundtext then
        	level.floatingtextid = level.floatingtextid + 1
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
				}, v._tag,v._cond
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
				}, v._tag,v._cond
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
				}, v._tag,v._cond
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
				}, v._tag,v._cond
			)
		end)
		level:fakehandler('updateroomangle',function(self,v) -- angle
			self:addevent(
				v.beat,
				"MoveRoom",
				{
					y = v.room,
					angle = getvalue(self.rooms[v.room], "angle", v.beat),
					duration = v.duration,
					ease = v.ease
				}, v._tag,v._cond
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
				}, v._tag,v._cond
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
				}, v._tag,v._cond
			)
		end)
		
		------------------------cameras
		
		level:fakehandler('updatecamx',function(self,v)
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
				}, v._tag,v._cond
			)
		end)
		level:fakehandler('updatecamy',function(self,v)
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
				}, v._tag,v._cond
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
				}, v._tag,v._cond
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
				}, v._tag,v._cond
			)
		end)
		
		
		--hand
		level:fakehandler('updatehands',function(self,v)
			self:addevent(
				v.beat,
				"ShowHands",
				{
					rooms = self:roomtable(v.room),
					hand = v.hand,
					action = v.action,
					align = v.align,
					instant = v.instant
				}, v._tag,v._cond
			)
		end)

		--perspective
		level:fakehandler('updateroomperspective',function(self,v)
			self:addevent(
				v.beat,
				"SetRoomPerspective",
				{
					y = v.room,
					cornerPositions = v.corners,
					duration = v.duration,
					ease = v.ease
				}, v._tag,v._cond
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

		level:condenser('MoveCamera',function(self,elist)
			local condensed = {}
			local groups = self:getcondensable(elist,{
				'rooms',
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