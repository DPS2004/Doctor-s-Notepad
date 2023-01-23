local rad = math.rad
local sin = math.sin
local cos = math.cos 

local CLASSYCOUNT = 9 -- 6 green segments + 1 yellow segment + 1 heart + 1 character-line connector

local extension = function(_level)
	_level.initqueue.queue(6,function(level,beat) --the number is in what order your extension will be loaded. lower = sooner

		local classyXSize = 24
		local classyXSheetSize = classyXSize + 8

		local classyHitXSize = 142
		local classyHitXSheetSize = classyHitXSize

		local classyHitTaggedEventsBeat = 0
		local varCount = 0

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
			},
			['synco'] = {
				appear = 'syncoPulse',
				disappear = 'neutral',
				pulse = 'happy',
				nextPulse = 'syncoPulseExit',
				swingLeft = 'W-Left',
				swingRight = 'W-Right',
				swingBounce = 'W-Bounce'
			}
		}

		-- timing: VeryEarly, SlightlyEarly, Perfect, SlightlyLate, VeryLate
		local function newHitConditional(name, row, timing)
			local cond = {}
			cond.id = #level.data.conditionals + #level.conditionals + 1
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

		local function newConditional(name, expression)
			local cond = {}
			cond.id = #level.data.conditionals + #level.conditionals + 1
			cond.level = level

			cond.name = name
			cond.expression = expression
			cond.red = false

			function cond:enable(val)
				cond.red = not not val
			end

			function cond:getid()
				if cond.red then
					return '~' .. self.id .. 'd0'
				else
					return self.id .. 'd0'
				end
			end

			function cond:save()
				table.insert(self.level.data.conditionals,
					{
						type = 'Custom',
						id = self.id,
						name = self.name,
						tag = tostring(self.id),
						expression = self.expression
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
			local usePivot = getvalue(row, 'classyPositionUsePivot', beat)

			local rowrad = rad(rowrot)

			-- row character position
			local char_relx = -285 * rowpivot * rowsx
			local charx, chary = rotate_point(char_relx, 0, rowrad)

			charx = charx + rowx
			chary = chary + rowy

			-- classybeat position
			local relx = cbeat._relativeX * rowsx
			local rely = 0

			if usePivot then

				local pivx = charx + relx - rowx
				local newpx = -(pivx / cbeat.sheetWidth * 100 - 50)

				cbeat:movepx(beat, newpx, 0, 'Linear')

				return rowx, rowy, charx, chary, true

			else

				local c_newx, c_newy = rotate_point(relx, rely, rowrad)

				local newx = charx + c_newx
				local newy = chary + c_newy

				return newx, newy, charx, chary

			end

		end

		local function calculate_beat(beat, row, i)
			local cbeat = row.classy[i]

			local delay = getvalue(row, 'classyDelay', beat)
			beat = beat + delay * cbeat.delayMultiplier

			return beat
		end

		local function reposition_classy(beat, row, index, duration, ease)

			local cbeat = row.classy[index]
			local finBeat = beat + duration

			local newx, newy, _, _, movePosInstant = calculate_classy_position(cbeat, row, beat)

			if movePosInstant then
				cbeat:move(beat, {
					x = newx / 3.52,
					y = newy / 1.98
				}, 0, 'Linear')
			end

			local Beat = calculate_beat(beat, row, index)
			cbeat:move(Beat, {
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

		local function findNextFreeTime(rowIndex, lastEvent, lastIndex)
			local events = level.data.events

			for i = lastIndex + 1, #events do
				local event = events[i]

				if event.row == rowIndex and event.type == 'PulseFreeTimeBeat' then
					return event
				end

			end

			-- fallback in case we dont find any other event, just return a fake event so the pulse never disappears
			return {bar = lastEvent.bar, beat = lastEvent.beat + 999, fake = true}

		end

		-- place tagged events at the last event in the level
		for _,e in ipairs(level.data.events) do
			classyHitTaggedEventsBeat = math.max(classyHitTaggedEventsBeat, getBeatFromPair(e.bar, e.beat))
		end

		-- row functions to wrap so we can reposition the classybeats and such
		local wrappedFunctions = {
			movex = function(row, beat, _, duration, ease)

				for i = 1, CLASSYCOUNT do

					local cbeat = row.classy[i]
					local finBeat = beat + duration

					local newx, newy = calculate_classy_position(cbeat, row, beat)

					local Beat = calculate_beat(beat, row, i)
					cbeat:movex(Beat, newx / 3.52, duration, ease)

				end

			end,
			movey = function(row, beat, _, duration, ease)

				for i = 1, CLASSYCOUNT do

					local cbeat = row.classy[i]
					local finBeat = beat + duration

					local newx, newy = calculate_classy_position(cbeat, row, beat)

					local Beat = calculate_beat(beat, row, i)
					cbeat:movey(Beat, newy / 1.98, duration, ease)

				end

			end,
			movesx = function(row, beat, _, duration, ease)

				for i = 1, CLASSYCOUNT do

					local cbeat = row.classy[i]
					local finBeat = beat + duration

					local newx, newy, charx, chary = calculate_classy_position(cbeat, row, beat)

					local rowsx = getvalue(row, 'sx', finBeat)
					local rowx = getvalue(row, 'x', beat)

					local Beat = calculate_beat(beat, row, i)
					cbeat:move(Beat, {
						x = newx / 3.52,
						sx = rowsx
					}, duration, ease)

				end

			end,
			movesy = function(row, beat, _, duration, ease)

				for i = 1, CLASSYCOUNT do

					local cbeat = row.classy[i]
					local finBeat = beat + duration

					local Beat = calculate_beat(beat, row, i)
					cbeat:movesy(Beat, getvalue(row, 'sy', finBeat), duration, ease)

				end

			end,
			setroom = function(row, beat, ...)

				for i = 1, CLASSYCOUNT do
					local Beat = calculate_beat(beat, row, i)
					row.classy[i]:setroom(Beat, ...)
				end

			end,
			setborder = function(row, beat, ...)
				
				for i = 1, CLASSYCOUNT do
					local Beat = calculate_beat(beat, row, i)
					row.classy[i]:setborder(Beat, ...)
				end

			end,
			settint = function(row, beat, ...)
				
				for i = 1, CLASSYCOUNT do
					local Beat = calculate_beat(beat, row, i)
					row.classy[i]:settint(Beat, ...)
				end

			end,
			setopacity = function(row, beat, opacity, duration, ease)
				
				for i = 1, CLASSYCOUNT do
					local Beat = calculate_beat(beat, row, i)
					row.classy[i]:setopacity(Beat, opacity, duration, ease)
				end

			end,
			show = function(row, beat)
				
				if getvalue(row, 'classyHidden', beat) then return end

				row:showchar(beat, 0)

				for i = 1, CLASSYCOUNT do

					local Beat = calculate_beat(beat, row, i)
					row.classy[i]:show(Beat)
				end

			end,
			hide = function(row, beat)

				if row.classy.special then return end

				for i = 1, CLASSYCOUNT do

					local Beat = calculate_beat(beat, row, i)
					row.classy[i]:hide(Beat)
				end

			end,
			showchar = function(row, beat)
				setvalue(row, 'classyHidden', beat, true)

				for i = 1, CLASSYCOUNT do

					local Beat = calculate_beat(beat, row, i)
					row.classy[i]:hide(Beat)
				end

			end,
			showrow = function(row, beat)
				setvalue(row, 'classyHidden', beat, false)

				row.classy.special = true
				row:hide(beat)
				row.classy.special = nil

				for i = 1, CLASSYCOUNT do

					local Beat = calculate_beat(beat, row, i)
					row.classy[i]:show(Beat)
				end

			end,
			movepivot = function(row, beat, pivot, duration, ease)
				reposition_all_classy(beat, row, duration, ease)
			end,
			rotate = function(row, beat, rotation, duration, ease)
				reposition_all_classy(beat, row, duration, ease)
			end
		}
		
		-- add classyinit() for every row
		for idx = 0, #level.rows do

			local row = level.rows[idx]
			local room = row.room

			-- generate classybeat stuff
			function row:classyinit(filename, disableHeartCrack)
				row.classyinit = function()
					error('classyinit() already called for this row!', 2)
				end

				filename = filename or 'ClassyBeat'
				disableHeartCrack = not not disableHeartCrack

				row.classy = {}
				row.classy.freePulse = 0 -- freetime support

				setvalue(row, 'classyPositionUsePivot', 0, false)
				setvalue(row, 'classyDelay', 0, 0)
				setvalue(row, 'classyHidden', 0, true)
				setvalue(row, 'syncoPulse', 0, -1)
				setvalue(row, 'syncoSwing', 0, 0)

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
						cbeat.sheetWidth = classyXSheetSize
						cbeat.delayMultiplier = i

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
						yellow.sheetWidth = classyHitXSheetSize
						yellow.delayMultiplier = 7

						row.classy[7] = yellow

						-- heart
						local heart = level:newdecoration(filename .. 'HitHeart', 70, room)
						heart:setvisibleatstart(false)

						heart._relativeX = classyX
						heart.width = classyHitXSize
						heart.sheetWidth = classyHitXSheetSize
						heart.delayMultiplier = 8

						row.classy[8] = heart

					end

					-- character-line connector
					do

						local connector = level:newdecoration(filename, idx*10 + 1, room)
						connector:setvisibleatstart(false)

						connector._relativeX = 5
						connector.width = 8
						connector.sheetWidth = classyXSheetSize
						connector.delayMultiplier = 0
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
					row.classy[7]:playexpression(classyHitTaggedEventsBeat, 'missed_early')

					level:conditional(condEarly)
					row.classy[7]:playexpression(classyHitTaggedEventsBeat, 'barely_early')

					level:conditional(condLate)
					row.classy[7]:playexpression(classyHitTaggedEventsBeat, 'barely_late')

					level:conditional(condVeryLate)
					row.classy[7]:playexpression(classyHitTaggedEventsBeat, 'missed_late')

					level:endconditional()

					level:tag('[onHit][row' .. idx .. ']CLASSYBEAT_HITBEAT_TAG')
					row.classy[7]:playexpression(classyHitTaggedEventsBeat, 'happy')

					level:tag('[onHeldPressHit][row' .. idx .. ']CLASSYBEAT_HOLDSTART_TAG')
					row.classy[7]:playexpression(classyHitTaggedEventsBeat, 'HeldStart')

					level:endtag()

				end

				-- create the pulse animations
				do
					local pulses = {}

					for i, event in ipairs(level.data.events) do

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

								local syncoPulse = getvalue(row, 'syncoPulse', beat)
								local syncoSwing = getvalue(row, 'syncoSwing', beat)

								local isSyncopationActive = syncoPulse > -1

								-- found the pulses
								for i = 1, 6 do
									local tick = i % 2 == 0 and tickEven or tickOdd

									local isSyncopated = isSyncopationActive and (i > syncoPulse + 1)
									local isNextFirstSyncopatedPulse = isSyncopationActive and (i == syncoPulse + 1)

									local beatSyncoAdd = isSyncopated and -(origTick / 2) or 0
									local tickSyncoAdd = isNextFirstSyncopatedPulse and -(origTick / 2) or 0

									table.insert(pulses, {
										pulse = i,
										beat = beat + beatSyncoAdd,
										tick = tick + tickSyncoAdd,
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

									curPattern = patternToExpression[char]
									setvalue(cbeat, 'currentPattern', beat, curPattern)

									if curPattern.appear then cbeat:playexpression(beat, curPattern.appear) end

								end

								setvalue(row, 'syncoPulse', beat, event.syncoBeat)
								setvalue(row, 'syncoSwing', beat, event.syncoSwing)

								if event.syncoBeat > -1 then
									local cbeat = row.classy[event.syncoBeat+1]

									setvalue(cbeat, 'currentPattern', beat, patternToExpression.synco)
									cbeat:playexpression(beat, patternToExpression.synco.appear)

								end

							elseif event.type == 'AddFreeTimeBeat' then
								row.classy.freePulse = 1 -- start freetime

								local nextPulse = findNextFreeTime(idx, event, i)

								local nextPulseBeat = getBeatFromPair(nextPulse.bar, nextPulse.beat)
								local thisPulseBeat = getBeatFromPair(event.bar, event.beat)

								local tick = nextPulseBeat - thisPulseBeat

								table.insert(pulses, {
									pulse = row.classy.freePulse,
									beat = thisPulseBeat,
									tick = tick,
									origTick = 0.5,
									swingType = 'straight',
									hold = event.hold,
									dontMakeExitAnimation = nextPulse.fake
								})

							elseif event.type == 'PulseFreeTimeBeat' then -- why are there two events :edegabudgetcuts:

								if row.classy.freePulse > 0 then -- only if we have an active freetime
									
									local action = event.action
									local pulse = row.classy.freePulse

									if action == 'Remove' then
										pulse = 0

									else

										if action == 'Increment' then
											pulse = math.min(pulse + 1, 7)

										elseif action == 'Decrement' then
											pulse = math.max(pulse - 1, 1)

										elseif action == 'Custom' then
											pulse = event.customPulse + 1

										end

										if pulse < 7 then
											-- normal pulse

											local nextPulse = findNextFreeTime(idx, event, i)

											local nextPulseBeat = getBeatFromPair(nextPulse.bar, nextPulse.beat)
											local thisPulseBeat = getBeatFromPair(event.bar, event.beat)

											local tick = nextPulseBeat - thisPulseBeat

											table.insert(pulses, {
												pulse = pulse,
												beat = thisPulseBeat,
												tick = tick,
												origTick = 0.5,
												swingType = 'straight',
												hold = event.hold,
												dontMakeExitAnimation = nextPulse.fake
											})
										else
											-- hit, so reset the freetime
											pulse = 0

										end

									end

									row.classy.freePulse = pulse

								end

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

							if pattern.nextPulse and not pulse.dontMakeExitAnimation then cbeat:playexpression(beat + tick, pattern.nextPulse) end

						else -- holding required, so use the special animations

							cbeat:playexpression(beat,        pattern.heldStart or 'HeldStart')
							cbeat:playexpression(beat + hold, pattern.heldEnd   or 'HeldEnd'  )

						end

					end

				end

				disableHeartCrack = true -- disable heart functionality for now

				-- heart cracking, if not diabled
				if not disableHeartCrack and varCount < 10 then

					level:tag('[onMiss][row' .. idx .. ']CLASSYBEAT_MISSBEAT_TAG')

					local variable = 'i' .. varCount
					varCount = varCount + 1

					level:rdcode(classyHitTaggedEventsBeat, variable .. '++')

					local stage1 = newConditional('DN_CLASSYBEAT_' .. idx .. '_CRACKSTAGE1', variable .. ' < missesToCrackHeart / 5 * 1')
					local stage2 = newConditional('DN_CLASSYBEAT_' .. idx .. '_CRACKSTAGE2', variable .. ' < missesToCrackHeart / 5 * 2')
					local stage3 = newConditional('DN_CLASSYBEAT_' .. idx .. '_CRACKSTAGE3', variable .. ' < missesToCrackHeart / 5 * 3')
					local stage4 = newConditional('DN_CLASSYBEAT_' .. idx .. '_CRACKSTAGE4', variable .. ' < missesToCrackHeart / 5 * 4')
					local stage5 = newConditional('DN_CLASSYBEAT_' .. idx .. '_CRACKSTAGE5', variable .. ' < missesToCrackHeart / 5 * 5')

					level:conditional(stage5)
					row.classy[8]:playexpression(classyHitTaggedEventsBeat, 'break')

					level:conditional(stage4)
					row.classy[8]:playexpression(classyHitTaggedEventsBeat, 'crack_4')

					level:conditional(stage3)
					row.classy[8]:playexpression(classyHitTaggedEventsBeat, 'crack_3')

					level:conditional(stage2)
					row.classy[8]:playexpression(classyHitTaggedEventsBeat, 'crack_2')

					level:conditional(stage1)
					row.classy[8]:playexpression(classyHitTaggedEventsBeat, 'crack_1')

					level:endconditional()
					level:endtag()

				elseif not disableHeartCrack and varCount > 9 then

					error('Only 10 classybeat rows can have heart cracking enabled! It must be disabled for any other rows.', 2)

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
					setvalue(row, 'classyHidden', beat, false)

					if getvalue(row, 'hidden', beat) then return end -- do nothing more if the row is hidden

					row:showchar(beat, 0)

					for _, cbeat in ipairs(row.classy) do
						cbeat:show(beat)
					end

				end

				function row:hideclassy(beat)
					setvalue(row, 'classyHidden', beat, true)

					if not getvalue(row, 'hidden', beat) then
						row:show(beat, 0)
					end

					for _, cbeat in ipairs(row.classy) do
						cbeat:hide(beat)
					end

				end

				-- makes classybeats' movements delayed by some amount of beats, good for fancy wavey effects and such
				function row:delayclassy(beat, delay)
					setvalue(row, 'classyDelay', beat, delay or 0)
				end

				function row:classyusepivot(beat, usePivot)
					setvalue(row, 'classyPositionUsePivot', beat, not not usePivot)

					for i = 1, CLASSYCOUNT do
						row.classy[i]:movepx(beat, 50)
					end
					reposition_all_classy(beat, row, 0, 'Linear')
				end

			end

		end
		
		-- fake event handlers
		
		-- add event type condensers
		
	end)
end

return extension