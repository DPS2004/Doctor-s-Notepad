local rad = math.rad
local sin = math.sin
local cos = math.cos 

local CLASSYCOUNT = 9 -- 6 green segments + 1 yellow segment + 1 heart + 1 character-line connector

local extension = function(_level)
	_level.initqueue.queue(6,function(level,beat) --the number is in what order your extension will be loaded. lower = sooner

		local classyXSize = 24
		local classyHitXSize = 142

		-- Set Row X pattern: xbrud-
		-- translation: X, left swing, swing bounce, up arrow, down arrow, normal

		local patternToExpression = {
			['x'] = {
				appear = 'X-Open',			-- runs on the Set Row X event
				disappear = 'X-Close',		-- runs on the Set Row X event
				pulse = 'X-Flash',			-- runs when the pulse is reached
				heldStart = 'X-Hold',		-- runs when the held beat starts on this pulse
				heldEnd = 'X-Hold',			-- runs when the held beat ends on this pulse
			},
			['-'] = {
				pulse = 'happy',
				nextPulse = 'barely',
				swingLeft = 'W-Left', 		-- swing to the left 	|\
				swingRight = 'W-Right',		-- swing to the right 	| > all required for swing to work
				swingBounce = 'W-Bounce'	-- swing bounce 		|/
			},
			['u'] = {
				pulse = 'U-Open',
				nextPulse = 'U-Close'
			},
			['d'] = {
				pulse = 'D-Open',
				nextPulse = 'D-Close'		-- runs when the next pulse is reached
			},
			['b'] = {
				pulse = 'W-Left',
				nextPulse = 'barely'
			},
			['r'] = {
				pulse = 'W-Bounce',
				nextPulse = 'barely'
			}
		}

		-- timing: VeryEarly, SlightlyEarly, Perfect, SlightlyLate, VeryLate
		local function newHitConditional(name, row, timing)
			local cond = {}
			cond.id = #level.conditionals + 1 + 9
			cond.level = level

			cond.name = name
			cond.row = row
			cond.result = timing

			function cond:getid()
				return self.id .. 'd0'
			end

			function cond:save()
				table.insert(self.level.data.conditionals,
					{
						type = 'LastHit',
						id = self.id,
						name = self.name,
						tag = tostring(self.id),
						row = self.row,
						result = self.result
					}
				)
			end

			table.insert(level.conditionals, cond)
			return cond

		end

		local function getBeatFromPair(bar, beat)

			-- calculate beat from bar, beat pair
			local crotchets = {}

			for eventi, event in ipairs(level.data.events) do
				if event.bar > bar then break end

				if event.type == "SetCrotchetsPerBar" then
					table.insert(crotchets, event.crotchetsPerBar)
				end
			end

			local crochet = 8
			for i = 1, bar - 1 do
				if crotchets[i] then crochet = crotchets[i] end
				beat = beat + crochet
			end

			return beat - 1

		end

		local function rotate_point(x, y, rot)
			local s, c = sin(rot), cos(rot)

			local nx = x*c - y*s
			local ny = y*c + x*s

			return nx, ny

		end

		local function calculate_classy_position(cbeat, row, beat)

			local rowx, rowy = getvalue(row, 'x', beat) * 3.52, getvalue(row, 'y', beat) * 1.98
			local rowrot = getvalue(row, 'rot', beat)
			local rowpivot = getvalue(row, 'pivot', beat)
			local rowsx, rowsy = getvalue(row, 'sx', beat), getvalue(row, 'sy', beat)

			local rowrad = rad(rowrot)

			-- row character position
			local char_relx = -282 * rowpivot * rowsx
			local charx, chary = rotate_point(char_relx, 0, rowrad)

			charx = charx + rowx
			chary = chary + rowy
			
			-- classybeat position
			local relx = cbeat._relativeX * rowsx
			local rely = 0

			local c_newx, c_newy = rotate_point(relx, rely, rowrad)

			local newx = charx + c_newx
			local newy = chary + c_newy

			return newx, newy, charx, chary

		end

		local function reposition_classy(beat, row, index, duration, ease)

			local cbeat = row.classy[index]
			local finBeat = beat + duration

			local newx, newy = calculate_classy_position(cbeat, row, beat)

			cbeat:move(beat, {
				x = newx / 3.52,
				y = newy / 1.98,
				rot = getvalue(row, 'rot', finBeat),
				sx = getvalue(row, 'sx', finBeat),
				sy = getvalue(row, 'sy', finBeat)
			}, duration, ease)

		end

		local function reposition_all_classy(beat, row, duration, ease)

			for i = 1, CLASSYCOUNT do
				reposition_classy(beat, row, i, duration, ease)
			end

		end

		-- row functions to wrap so we can reposition the classybeats and such
		local wrappedFunctions = {
			movex = function(row, beat, _, duration, ease)

				for i = 1, CLASSYCOUNT do

					local cbeat = row.classy[i]
					local finBeat = beat + duration

					local newx, newy = calculate_classy_position(cbeat, row, beat)

					cbeat:movex(beat, newx / 3.52, duration, ease)

				end

			end,
			movey = function(row, beat, _, duration, ease)

				for i = 1, CLASSYCOUNT do

					local cbeat = row.classy[i]
					local finBeat = beat + duration

					local newx, newy = calculate_classy_position(cbeat, row, beat)

					cbeat:movey(beat, newy / 1.98, duration, ease)

				end

			end,
			movesx = function(row, beat, _, duration, ease)

				for i = 1, CLASSYCOUNT do

					local cbeat = row.classy[i]
					local finBeat = beat + duration

					local newx, newy, charx, chary = calculate_classy_position(cbeat, row, beat)

					local rowsx = getvalue(row, 'sx', finBeat)
					local rowx = getvalue(row, 'x', beat)

					cbeat:move(beat, {
						x = newx / 3.52,
						sx = rowsx
					}, duration, ease)

				end

			end,
			movesy = function(row, beat, _, duration, ease)

				for i = 1, CLASSYCOUNT do

					local cbeat = row.classy[i]
					local finBeat = beat + duration

					cbeat:movesy(beat, getvalue(row, 'sy', finBeat), duration, ease)

				end

			end,
			setroom = function(row, ...)

				for i = 1, CLASSYCOUNT do
					row.classy[i]:setroom(...)
				end

			end,
			setborder = function(row, ...)
				
				for i = 1, CLASSYCOUNT do
					row.classy[i]:setborder(...)
				end

			end,
			settint = function(row, ...)
				
				for i = 1, CLASSYCOUNT do
					row.classy[i]:settint(...)
				end

			end,
			setopacity = function(row, beat, opacity, duration, ease)
				
				for i = 1, CLASSYCOUNT do
					row.classy[i]:setopacity(beat, opacity, duration, ease)
				end

			end,
			show = function(row, beat)
				
				if row.classy.hidden then return end

				row:showchar(beat, 0)

				for i = 1, CLASSYCOUNT do
					row.classy[i]:show(beat)
				end

			end,
			hide = function(row, beat)

				if row.classy.special then return end

				for i = 1, CLASSYCOUNT do
					row.classy[i]:hide(beat)
				end

			end,
			showchar = function(row, beat)
				row.classy.hidden = true

				for i = 1, CLASSYCOUNT do
					row.classy[i]:hide(beat)
				end

			end,
			showrow = function(row, beat)
				row.classy.hidden = false

				row.classy.special = true
				row:hide(beat)
				row.classy.special = nil

				for i = 1, CLASSYCOUNT do
					row.classy[i]:show(beat)
				end

			end,
			movepivot = reposition_all_classy,
			rotate = reposition_all_classy
		}
		
		-- add classyinit() for every row
		for idx = 0, #level.rows do

			local row = level.rows[idx]
			local room = row.room

			-- generate classybeat stuff
			function row:classyinit(filename, disableHeart)
				row.classyinit = function()
					error('classyinit() already called for this row!', 2)
				end

				disableHeart = not not disableHeart
				filename = filename or 'ClassyBeat'

				row.classy = {}
				row.classy.hidden = true

				-- generate the row
				do
					local classyX = 5

					-- green segments
					for i = 1, 6 do

						local cbeat = level:newdecoration(filename, idx*10, room)
						cbeat:setvisibleatstart(false)

						classyX = classyX + classyXSize

						cbeat._relativeX = classyX
						cbeat.width = classyXSize

						setvalue(cbeat, 'currentPattern', 0, patternToExpression['-'])

						row.classy[i] = cbeat

					end

					-- hitbar
					do

						classyX = classyX + classyHitXSize/2 + 8

						-- yellow part
						local yellow = level:newdecoration(filename .. 'Hit', 60, room)
						yellow:setvisibleatstart(false)

						yellow._relativeX = classyX
						yellow.width = classyHitXSize

						row.classy[7] = yellow

						-- heart
						local heart = level:newdecoration(filename .. 'HitHeart', 70, room)
						heart:setvisibleatstart(false)

						heart._relativeX = classyX
						heart.width = classyHitXSize

						row.classy[8] = heart

					end

					-- character-line connector
					do

						local connector = level:newdecoration(filename, idx*10 + 1, room)
						connector:setvisibleatstart(false)

						connector._relativeX = 8
						connector.width = 8
						connector:movesx(0, 8 / classyXSize, 0, 'Linear')

						row.classy[9] = connector

					end

				end

				-- initial reposition
				reposition_all_classy(0, row, 0, 'Linear')

				-- make conditionals and hitbar animations
				do

					local condVeryEarly = newHitConditional('DN_CLASSYBEAT_' .. idx .. '_VERYEARLY', idx, 'VeryEarly')
					local condEarly = newHitConditional('DN_CLASSYBEAT_' .. idx .. '_EARLY', idx, 'SlightlyEarly')
					local condPerfect = newHitConditional('DN_CLASSYBEAT_' .. idx .. '_PERFECT', idx, 'Perfect')
					local condLate = newHitConditional('DN_CLASSYBEAT_' .. idx .. '_LATE', idx, 'SlightlyLate')
					local condVeryLate = newHitConditional('DN_CLASSYBEAT_' .. idx .. '_VERYLATE', idx, 'VeryLate')

					level:tag('[onMiss][row' .. idx .. ']CLASSYBEAT_MISSBEAT_TAG')

					level:conditional(condVeryEarly)
					row.classy[7]:playexpression(0, 'missed_early')

					level:conditional(condEarly)
					row.classy[7]:playexpression(0, 'barely_early')

					level:conditional(condLate)
					row.classy[7]:playexpression(0, 'barely_late')

					level:conditional(condVeryLate)
					row.classy[7]:playexpression(0, 'missed_late')

					level:endconditional()

					level:tag('[onHit][row' .. idx .. ']CLASSYBEAT_HITBEAT_TAG')
					row.classy[7]:playexpression(0, 'happy')

					level:tag('[onHeldPressHit][row' .. idx .. ']CLASSYBEAT_HOLDSTART_TAG')
					row.classy[7]:playexpression(0, 'HeldStart')

					level:endtag()

				end

				-- create the pulse animations
				do
					local pulses = {}

					for _,event in ipairs(level.data.events) do

						if event.row == idx then

							if event.type == 'AddClassicBeat' then

								local beat = getBeatFromPair(event.bar, event.beat)
								local swing = event.swing
								local swingType = 'straight'

								local origTick = event.tick
								local tickEven = event.tick
								local tickOdd = event.tick

								-- swing support
								if swing > 0 then
									tickEven = swing
									tickOdd = origTick*2 - tickEven
									
									if tickEven < tickOdd then
										swingType = 'startLeft'
									else
										swingType = 'startRight'
									end

								end

								-- found the pulses
								for i = 1, 6 do
									local tick = i % 2 == 0 and tickEven or tickOdd

									table.insert(pulses, {
										pulse = i,
										beat = beat,
										tick = tick,
										origTick = origTick,
										swingType = swingType,
										hold = event.hold
									})

									beat = beat + tick

								end

							elseif event.type == 'SetRowXs' then

								local beat = getBeatFromPair(event.bar, event.beat)
								local pattern = event.pattern

								for i = 1, 6 do

									local char = pattern:sub(i,i)
									local cbeat = row.classy[i]
									local curPattern = getvalue(cbeat, 'currentPattern', beat)

									if curPattern.disappear then cbeat:playexpression(beat, curPattern.disappear) end

									setvalue(cbeat, 'currentPattern', beat, patternToExpression[char])
									curPattern = getvalue(cbeat, 'currentPattern', beat)

									if curPattern.appear then cbeat:playexpression(beat, curPattern.appear) end

								end

							elseif event.type == 'AddFreeTimeBeat' or event.type == 'PulseFreeTimeBeat' then -- why are there two events :edegabudgetcuts:



							end

						end

					end

					for _,pulse in ipairs(pulses) do

						local idx = pulse.pulse
						local beat = pulse.beat
						local origTick = pulse.origTick
						local tick = pulse.tick
						local hold = pulse.hold

						local cbeat = row.classy[idx]
						local pattern = getvalue(cbeat, 'currentPattern', beat)

						if hold == 0 then -- pulse normally, no holding required

							local swingFlag = (pulse.swingType ~= 'straight') and pattern.swingLeft and pattern.swingRight and pattern.swingBounce

							if swingFlag then -- use swing expressions if we have all of them and they're needed

								-- awful
								local swing_expr1, swing_expr2 = pattern.swingLeft, pattern.swingRight

								if pulse.swingType == 'startLeft' then
									swing_expr1, swing_expr2 = pattern.swingLeft, pattern.swingBounce
								end

								if tick > origTick then cbeat:playexpression(beat, swing_expr1)
								else cbeat:playexpression(beat, swing_expr2)
								end

							else -- use normal expressions in other cases

								if pattern.pulse then cbeat:playexpression(beat, pattern.pulse) end

							end

							if pattern.nextPulse then cbeat:playexpression(beat + tick, pattern.nextPulse) end

						else -- holding required, so use the special animations

							cbeat:playexpression(beat,        pattern.heldStart or 'HeldStart')
							cbeat:playexpression(beat + hold, pattern.heldEnd   or 'HeldEnd'  )

						end

					end

				end
	
				-- wrap row functions
				for funcName, addedFunc in pairs(wrappedFunctions) do

					local _func = row[funcName]

					-- i love varargs
					row[funcName] = function(...)
						_func(...)
						addedFunc(...)
					end

				end

				function row:showclassy(beat)
					row.classy.hidden = false

					if getvalue(row, 'hidden', beat) then return end -- do nothing more if the row is hidden

					row:showchar(beat, 0)

					for _, cbeat in ipairs(row.classy) do
						cbeat:show(beat)
					end

				end

				function row:hideclassy(beat)
					row.classy.hidden = true

					if not getvalue(row, 'hidden', beat) then
						row:show(beat, 0)
					end

					for _, cbeat in ipairs(row.classy) do
						cbeat:hide(beat)
					end

				end

			end

		end
		
		-- fake event handlers
		
		-- add event type condensers
		
	end)
end

return extension