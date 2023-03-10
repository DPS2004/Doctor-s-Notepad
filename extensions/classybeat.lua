local rad = math.rad
local sin = math.sin
local cos = math.cos 
local abs = math.abs

local CLASSYCOUNT = 9 -- 6 green segments + 1 yellow segment + 1 heart + 1 character-line connector
local MAXVARCOUNT = 10 -- maximum amount of ints available

-- used for creating the decos and copying over required files
local CLASSYBASEFILENAME = 'ClassyBeat'
local CLASSYHITFILENAME = CLASSYBASEFILENAME .. 'Hit'
local CLASSYHITHEARTFILENAME = CLASSYHITFILENAME .. 'Heart'
local CLASSYFILENAMEENDINGS = {'.json', '.png', '_freeze.png', '_glow.png', '_outline.png'}
local CLASSYBASEPATH = 'ccs/' .. CLASSYBASEFILENAME

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

		local function newTimeConditional(name, times)
			local cond = {}
			cond.id = #level.data.conditionals + #level.conditionals + 1
			cond.level = level

			cond.name = name
			cond.times = times

			function cond:getid()
				return self.id .. 'd0'
			end

			function cond:save()
				table.insert(self.level.data.conditionals,
					{
						type = 'TimesExecuted',
						id = self.id,
						name = self.name,
						tag = tostring(self.id),
						maxTimes = self.times
					}
				)
			end

			table.insert(level.conditionals, cond)
			return cond

		end
		local onetime = {}

		local function newConditional(name, expression)
			local cond = {}
			cond.id = #level.data.conditionals + #level.conditionals + 1
			cond.level = level

			cond.name = name
			cond.expression = expression
			cond.red = false

			function cond:setred(val)
				cond.red = not not val
			end

			function cond:getid()
				if cond.red then
					return onetime.id .. '&~' .. self.id .. 'd0'
				else
					return onetime.id .. '&' .. self.id .. 'd0'
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

			local xOffset = getvalue(cbeat, 'classy_xOffset', beat) * 3.52
			local yOffset = getvalue(cbeat, 'classy_yOffset', beat) * 1.98

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

				local pivx = char_relx + relx
				local newpx = -(pivx / rowsx / cbeat.sheetWidth * 100 - 50)

				cbeat:movepx(beat, newpx + getvalue(cbeat, 'classy_pxOffset', beat) - 50, 0, 'Linear')

				return rowx + xOffset, rowy + yOffset, charx, chary, true

			else

				local c_newx, c_newy = rotate_point(relx, rely, rowrad)

				local newx = charx + c_newx
				local newy = chary + c_newy

				return newx + xOffset, newy + yOffset, charx, chary

			end

		end

		local function calculate_beat(beat, row, i)
			local cbeat = row._classylist[i]

			local delay = getvalue(row, 'classyDelay', beat)
			beat = beat + delay * cbeat.delayMultiplier

			return beat
		end

		local function reposition_classy(beat, row, index, duration, ease)

			local cbeat = row._classylist[index]
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
				rot = getvalue(row, 'rot', finBeat) + getvalue(cbeat, 'classy_rotOffset', Beat),
				sx = getvalue(row, 'sx', finBeat) + getvalue(cbeat, 'classy_sxOffset', Beat) - 1,
				sy = getvalue(row, 'sy', finBeat) + getvalue(cbeat, 'classy_syOffset', Beat) - 1,
				py = getvalue(cbeat, 'classy_pyOffset', Beat)
			}, duration, ease)

		end

		local function reposition_all_classy(beat, row, duration, ease)

			for i = 1, CLASSYCOUNT do
				reposition_classy(beat, row, i, duration, ease)
			end

		end

		local function calculate_freetime_swing(tick, origTick)

			if tick > origTick then
				return 'startLeft'
			elseif tick < origTick then
				return 'startRight'
			end

			return 'straight'
		end

		local function findNextFreeTime(rowIndex, lastEvent, lastIndex)
			local events = level.data.events

			for i = lastIndex + 1, #events do
				local event = events[i]

				if event.row == rowIndex and event.type == 'PulseFreeTimeBeat' then
					return event, i
				end

			end

			-- fallback in case we dont find any other event, just return a fake event so the pulse never disappears
			return {bar = lastEvent.bar, beat = lastEvent.beat + 999, fake = true}, lastIndex+1

		end

		local function combinePath(path, file)
			return path .. '/' .. file
		end

		local function copyFiles(srcpath, filename, dstpath)

			for _,v in ipairs(CLASSYFILENAMEENDINGS) do
				local srcfilename = combinePath(srcpath, filename) .. v
				local srcfile = io.open(srcfilename, 'rb')

				local dstfilename = combinePath(dstpath, filename) .. v
				local dstfile = io.open(dstfilename, 'wb')

				print('Copying file "' .. srcfilename .. '" to "' .. dstfilename .. '"')

				dstfile:write(srcfile:read('*all'))

				srcfile:close()
				dstfile:close()

			end

		end

		local function copyClassybeatFiles()

			local dstpath = inlevel --h?

			-- copy base
			copyFiles(CLASSYBASEPATH, CLASSYBASEFILENAME, dstpath)

			-- copy hit
			copyFiles(CLASSYBASEPATH, CLASSYHITFILENAME, dstpath)

			-- copy hitheart
			copyFiles(CLASSYBASEPATH, CLASSYHITHEARTFILENAME, dstpath)

			copyClassybeatFiles = function() end -- overwrite it so it does nothing later

		end

		local function closeEnough(a, b)
			return abs(a - b) < 0.001
		end

		-- place tagged events at the last event in the level
		for _,e in ipairs(level.data.events) do
			classyHitTaggedEventsBeat = math.max(classyHitTaggedEventsBeat, getBeatFromPair(e.bar, e.beat))
		end

		-- row functions to wrap so we can reposition the classybeats and such
		local wrappedFunctions = {
			movex = function(row, beat, _, duration, ease)

				for i = 1, CLASSYCOUNT do

					local cbeat = row._classylist[i]
					local finBeat = beat + duration

					local newx, newy = calculate_classy_position(cbeat, row, beat)

					local Beat = calculate_beat(beat, row, i)
					cbeat:movex(Beat, newx / 3.52, duration, ease)

				end

			end,
			movey = function(row, beat, _, duration, ease)

				for i = 1, CLASSYCOUNT do

					local cbeat = row._classylist[i]
					local finBeat = beat + duration

					local newx, newy = calculate_classy_position(cbeat, row, beat)

					local Beat = calculate_beat(beat, row, i)
					cbeat:movey(Beat, newy / 1.98, duration, ease)

				end

			end,
			movesx = function(row, beat, _, duration, ease)

				for i = 1, CLASSYCOUNT do

					local cbeat = row._classylist[i]
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

					local cbeat = row._classylist[i]
					local finBeat = beat + duration

					local Beat = calculate_beat(finBeat, row, i)
					cbeat:movesy(Beat, getvalue(row, 'sy', finBeat) + getvalue(cbeat, 'classy_syOffset', finBeat), duration, ease)

				end

			end,
			setroom = function(row, beat, room)

				for i = 1, CLASSYCOUNT do
					local Beat = calculate_beat(beat, row, i)
					row._classylist[i]:setroom(Beat, room)
					reposition_all_classy(Beat, row, 0, 'Linear')
				end

			end,
			setborder = function(row, beat, ...)
				
				for i = 1, CLASSYCOUNT do
					local Beat = calculate_beat(beat, row, i)
					row._classylist[i]:setborder(Beat, ...)
				end

			end,
			settint = function(row, beat, ...)
				
				for i = 1, CLASSYCOUNT do
					local Beat = calculate_beat(beat, row, i)
					row._classylist[i]:settint(Beat, ...)
				end

			end,
			setopacity = function(row, beat, opacity, duration, ease)
				
				for i = 1, CLASSYCOUNT do
					local Beat = calculate_beat(beat, row, i)
					row._classylist[i]:setopacity(Beat, opacity, duration, ease)
				end

			end,
			show = function(row, beat)
				if getvalue(row, 'classyHidden', beat) then return end

				row:showchar(beat, 0)

				for i = 1, CLASSYCOUNT do

					local Beat = calculate_beat(beat, row, i)
					row._classylist[i]:show(Beat)
				end

			end,
			hide = function(row, beat)

				for i = 1, CLASSYCOUNT do

					local Beat = calculate_beat(beat, row, i)
					row._classylist[i]:hide(Beat)
				end

			end,
			showchar = function(row, beat)

				for i = 1, CLASSYCOUNT do

					local Beat = calculate_beat(beat, row, i)
					row._classylist[i]:hide(Beat)
				end

			end,
			showrow = function(row, beat)
				local hidden = getvalue(row, 'classyHidden', beat)

				if not hidden then
					row:hide(beat, 0)
				end

				for i = 1, CLASSYCOUNT do

					local Beat = calculate_beat(beat, row, i)

					if not hidden then
						row._classylist[i]:show(Beat)
					end
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
			if not row then break end -- failsafe for when there are 0 rows idk its weird

			local room = row.room

			-- generate classybeat stuff
			function row:classyinit(disableHeartCrack)
				row._classylistinit = function()
					error('classyinit() already called for this row!', 2)
				end

				disableHeartCrack = not not disableHeartCrack
				onetime = newTimeConditional('DN_CLASSYBEAT_RUNONCE', 1) -- add the conditional only if its used

				copyClassybeatFiles(CLASSYBASEFILENAME)

				row._classylist = {}
				row._classylist.freePulse = 0 -- freetime support

				row.classy = {
					beats = {},
					hitbar = nil,
					heart = nil,
					connector = nil
				}

				setvalue(row, 'classyPositionUsePivot', 0, false)
				setvalue(row, 'classyDelay', 0, 0)
				setvalue(row, 'classyHidden', 0, true)
				setvalue(row, 'syncoPulse', 0, -1)
				setvalue(row, 'syncoSwing', 0, 0)
				setvalue(row, 'classyLocked', 0, false)

				-- generate the row
				do
					local classyX = 6.5

					-- green segments
					for i = 1, 6 do

						local cbeat = level:newdecoration(CLASSYBASEFILENAME, idx*10, room)
						cbeat:setvisibleatstart(false)

						classyX = classyX + classyXSize

						cbeat._relativeX = classyX
						cbeat.width = classyXSize
						cbeat.sheetWidth = classyXSheetSize
						cbeat.delayMultiplier = i

						setvalue(cbeat, 'currentPattern', 0, patternToExpression['-'])

						row._classylist[i] = cbeat
						row.classy.beats[i] = cbeat

					end

					-- hitbar
					do

						classyX = classyX + classyHitXSize/2 + 8

						-- yellow part
						local yellow = level:newdecoration(CLASSYHITFILENAME, 60, room)
						yellow:setvisibleatstart(false)

						yellow._relativeX = classyX
						yellow.width = classyHitXSize
						yellow.sheetWidth = classyHitXSheetSize
						yellow.delayMultiplier = 7

						row._classylist[7] = yellow
						row.classy.hitbar = yellow

						-- heart
						local heart = level:newdecoration(CLASSYHITHEARTFILENAME, 70, room)
						heart:setvisibleatstart(false)

						heart._relativeX = classyX
						heart.width = classyHitXSize
						heart.sheetWidth = classyHitXSheetSize
						heart.delayMultiplier = 8

						row._classylist[8] = heart
						row.classy.heart = heart

					end

					-- character-line connector
					do

						local connector = level:newdecoration(CLASSYBASEFILENAME, idx*10 + 1, room)
						connector:setvisibleatstart(false)

						connector._relativeX = 8
						connector.width = 8
						connector.sheetWidth = classyXSheetSize
						connector.delayMultiplier = 0
						connector:movesx(0, 8 / classyXSize, 0, 'Linear')

						row._classylist[9] = connector
						row.classy.connector = connector

					end

					for i = 1, CLASSYCOUNT do

						local cbeat = row._classylist[i]

						setvalue(cbeat, 'classy_xOffset', 0, 0)
						setvalue(cbeat, 'classy_yOffset', 0, 0)
						setvalue(cbeat, 'classy_sxOffset', 0, 1)
						setvalue(cbeat, 'classy_syOffset', 0, 1)
						setvalue(cbeat, 'classy_pxOffset', 0, 50)
						setvalue(cbeat, 'classy_pyOffset', 0, 50)
						setvalue(cbeat, 'classy_rotOffset', 0, 0)

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
					row._classylist[7]:playexpression(classyHitTaggedEventsBeat, 'missed_early')

					level:conditional(condEarly)
					row._classylist[7]:playexpression(classyHitTaggedEventsBeat, 'barely_early')

					level:conditional(condLate)
					row._classylist[7]:playexpression(classyHitTaggedEventsBeat, 'barely_late')

					level:conditional(condVeryLate)
					row._classylist[7]:playexpression(classyHitTaggedEventsBeat, 'missed_late')

					level:endconditional()

					level:tag('[onHit][row' .. idx .. ']CLASSYBEAT_HITBEAT_TAG')
					row._classylist[7]:playexpression(classyHitTaggedEventsBeat, 'happy')

					level:tag('[onHeldPressHit][row' .. idx .. ']CLASSYBEAT_HOLDSTART_TAG')
					row._classylist[7]:playexpression(classyHitTaggedEventsBeat, 'HeldStart')

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
									local isNextSyncopationPulse = isSyncopationActive and (i == syncoPulse)

									local beatSyncoAdd = isSyncopated and -(origTick / 2) or 0
									local tickSyncoAdd = isNextFirstSyncopatedPulse and -(origTick / 2) or 0

									local forceSwing = (isNextSyncopationPulse and 'swingLeft') or (isNextFirstSyncopatedPulse and 'swingRight') or nil

									table.insert(pulses, {
										pulse = i,
										beat = beat + beatSyncoAdd,
										tick = tick + tickSyncoAdd,
										origTick = origTick,
										swingType = swingType,
										hold = event.hold,
										forceSwing = forceSwing
									})

									beat = beat + tick

								end

							elseif event.type == 'SetRowXs' then

								local beat = getBeatFromPair(event.bar, event.beat)
								local pattern = event.pattern

								for i = 1, 6 do

									local char = pattern:sub(i,i)
									local cbeat = row._classylist[i]
									local curPattern = getvalue(cbeat, 'currentPattern', beat)

									if curPattern.disappear then cbeat:playexpression(beat, curPattern.disappear) end

									curPattern = patternToExpression[char]
									setvalue(cbeat, 'currentPattern', beat, curPattern)

									if curPattern.appear then cbeat:playexpression(beat, curPattern.appear) end

								end

								setvalue(row, 'syncoPulse', beat, event.syncoBeat)
								setvalue(row, 'syncoSwing', beat, event.syncoSwing)

								if event.syncoBeat > -1 then
									local cbeat = row._classylist[event.syncoBeat+1]

									setvalue(cbeat, 'currentPattern', beat, patternToExpression.synco)
									cbeat:playexpression(beat, patternToExpression.synco.appear)

								end

							elseif event.type == 'AddFreeTimeBeat' then

								local pulseNum = event.pulse + 1
								local freeTimePulses = {}
								local freeTimePulseDistances = {}

								local thisPulse = event
								local thisPulseIndex = i

								while pulseNum < 7 do

									if thisPulse.type == 'PulseFreeTimeBeat' then
										
										if thisPulse.action == 'Increment' then
											pulseNum = math.min(7, pulseNum + 1)
										elseif thisPulse.action == 'Decrement' then
											pulseNum = math.max(1, pulseNum - 1)
										elseif thisPulse.action == 'Custom' then
											pulseNum = thisPulse.customPulse + 1
										end

									end

									freeTimePulses[#freeTimePulses+1] = {
										event = thisPulse,
										index = pulseNum,
										beat = getBeatFromPair(thisPulse.bar, thisPulse.beat)
									}

									if thisPulse.action == 'Remove' then
										break
									end

									local nextPulse, nextPulseIndex = findNextFreeTime(idx, thisPulse, thisPulseIndex)

									if nextPulse.fake then break end

									thisPulse = nextPulse
									thisPulseIndex = nextPulseIndex

								end

								thisPulse = nil
								thisPulseIndex = nil

								local origTick = -1

								-- banana detection algorithm lol
								if #freeTimePulses > 6 then

									local firstPulse = freeTimePulses[1]
									local seventhPulse = freeTimePulses[7]

									local totalTime = seventhPulse.beat - firstPulse.beat
									local segmentLength = totalTime / 6

									if origTick < 0 then

										local correctBeats = 0

										for i = 1, #freeTimePulses do

											local thisPulse = freeTimePulses[i]

											if closeEnough(firstPulse.beat + segmentLength*(i-1), thisPulse.beat) then

												correctBeats = correctBeats + 1

											end

										end

										if correctBeats > 3 then
											origTick = segmentLength
										end

									end

									if origTick < 0 then

										local distanceCounts = {}

										for i = 1, #freeTimePulses - 1 do
											local distance = freeTimePulses[i+1].beat - freeTimePulses[i].beat

											freeTimePulseDistances[i] = distance
											distanceCounts[distance] = (distanceCounts[distance] or 0) + 1
										end

										for distance, count in pairs(distanceCounts) do

											if count > #freeTimePulses / 2 then
												origTick = distance
												break

											end

										end

									end

									if origTick < 0 then

										local equalDistanceThrees = 0

										for i = 1, #freeTimePulses, 3 do

											if closeEnough(firstPulse.beat + segmentLength * (i-1), freeTimePulses[i].beat) then
												equalDistanceThrees = equalDistanceThrees + 1
											end

										end

										if equalDistanceThrees > 2 then
											origTick = segmentLength

										end

									end

								end

								for i = 1, #freeTimePulses-1 do

									local thisPulse = freeTimePulses[i]
									local nextPulse = freeTimePulses[i+1]

									local thisEvent = thisPulse.event
									local thisPulseIndex = thisPulse.index
									local nextEvent = nextPulse.event

									local tick = nextPulse.beat - thisPulse.beat
									local usedOrigTick = (origTick > -1) and origTick or tick

									table.insert(pulses, {
										pulse = thisPulseIndex,
										beat = thisPulse.beat,
										tick = tick,
										origTick = usedOrigTick,
										swingType = calculate_freetime_swing(tick, usedOrigTick),
										hold = thisEvent.hold,
										dontMakeExitAnimation = nextEvent.fake
									})

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
						local forceSwing = pulse.forceSwing

						local cbeat = row._classylist[idx]
						local pattern = getvalue(cbeat, 'currentPattern', beat)

						if hold == 0 then -- pulse normally, no holding required

							local canPlayForced = forceSwing and pattern[forceSwing]

							if canPlayForced then -- a swing animation is forced, play it if the pattern has it

								cbeat:playexpression(beat, pattern[forceSwing])

							else -- otherwise, proceed as normal

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

							end

							if pattern.nextPulse and not pulse.dontMakeExitAnimation then cbeat:playexpression(beat + tick, pattern.nextPulse) end

						else -- holding required, so use the special animations

							cbeat:playexpression(beat,        pattern.heldStart or 'HeldStart')
							cbeat:playexpression(beat + hold, pattern.heldEnd   or 'HeldEnd'  )

						end

					end

				end

				-- heart cracking, if not diabled
				if not disableHeartCrack and varCount < MAXVARCOUNT then

					level:tag('[onMiss][row' .. idx .. ']CLASSYBEAT_MISSBEAT_TAG')

					local variable = 'i' .. varCount
					varCount = varCount + 1

					local variablePlusOne = '(' .. variable .. '+ 1)'

					local stage1 = newConditional('DN_CLASSYBEAT_' .. idx .. '_CRACKSTAGE1', variablePlusOne .. ' / missesToCrackHeart * 5 < 1')
					local stage2 = newConditional('DN_CLASSYBEAT_' .. idx .. '_CRACKSTAGE2', variablePlusOne .. ' / missesToCrackHeart * 5 < 2')
					local stage3 = newConditional('DN_CLASSYBEAT_' .. idx .. '_CRACKSTAGE3', variablePlusOne .. ' / missesToCrackHeart * 5 < 3')
					local stage4 = newConditional('DN_CLASSYBEAT_' .. idx .. '_CRACKSTAGE4', variablePlusOne .. ' / missesToCrackHeart * 5 < 4')
					local stage5 = newConditional('DN_CLASSYBEAT_' .. idx .. '_CRACKSTAGE5', variablePlusOne .. ' / missesToCrackHeart * 5 < 5')

					stage1:setred(true)
					stage2:setred(true)
					stage3:setred(true)
					stage4:setred(true)
					stage5:setred(true)

					level:conditional(stage1)
					row._classylist[8]:playexpression(classyHitTaggedEventsBeat, 'crack_1')

					level:conditional(stage2)
					row._classylist[8]:playexpression(classyHitTaggedEventsBeat, 'crack_2')

					level:conditional(stage3)
					row._classylist[8]:playexpression(classyHitTaggedEventsBeat, 'crack_3')

					level:conditional(stage4)
					row._classylist[8]:playexpression(classyHitTaggedEventsBeat, 'crack_4')

					level:conditional(stage5)
					row._classylist[8]:playexpression(classyHitTaggedEventsBeat, 'break')

					level:endconditional()

					level:rdcode(classyHitTaggedEventsBeat, variable .. '++', 100)
					level:endtag()

				elseif not disableHeartCrack and varCount >= MAXVARCOUNT then

					error('Only ' .. MAXVARCOUNT .. ' classybeat rows can have heart cracking enabled! It must be disabled for any other rows.', 2)

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

					if getvalue(row, 'hidden', beat) then return end -- do nothing more if the row is hidden

					row:showchar(beat, 0)

					for _, cbeat in ipairs(row._classylist) do
						cbeat:show(beat)
					end

					setvalue(row, 'classyHidden', beat, false)
				end

				function row:hideclassy(beat)
					local hidden = getvalue(row, 'classyHidden', beat)
					setvalue(row, 'classyHidden', beat, true)

					if not getvalue(row, 'hidden', beat) then
						row:show(beat, 0)
					elseif not hidden then
						row:showrow(beat, 0)
					end

					for _, cbeat in ipairs(row._classylist) do
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
						row._classylist[i]:movepx(beat, 50)
					end
					reposition_all_classy(beat, row, 0, 'Linear')
				end

				function row:lockposition(beat, lock)
					setvalue(row, 'classyLocked', beat, not not lock)

				end

				function row:classyoffset(beat, part, p, duration, ease)
					if not getvalue(row, 'classyLocked', beat) then return end
					if part < 1 then part = 9 end -- connector patch lol

					local cbeat = row._classylist[part]
					for k,v in pairs(p) do
						if k == 'rotate' then k = 'rot' end

						local newkey = 'classy_' .. k .. 'Offset'

						if pcall(getvalue, cbeat, newkey, 0) then
							setvalue(cbeat, newkey, beat, v)
						else
							error(k .. ' not a valid movement!', 2)
						end

					end

					reposition_classy(beat, row, part, duration, ease)

				end

			end

		end
		
		-- fake event handlers
		
		-- add event type condensers
		
	end)
end

return extension