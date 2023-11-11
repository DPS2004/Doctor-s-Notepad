local extension = function(_level)

	local BOSSBARNAME = 'BossBar'
	local BOSSBARPATH = 'ccs/' .. BOSSBARNAME
	local BOSSBARDEPTH = -10000
	local VIRUSPREFIX = 'virus'
	local PATIENTPREFIX = 'patient'
	local VIRUSBAROFFSETX = 8 / 3.52
	local VIRUSBAROFFSETY = 194 / 1.98
	local PATIENTBAROFFSETX = 9 / 3.52 -- offset from the virus bar
	local PATIENTBAROFFSETY = -14 / 1.98
	local DISABLEDOFFSETY = 33 / 1.98
	local VIRUSBARCOLOR = 'BC2BEC'
	local PATIENTBARCOLOR = '05DBDD'
	local LOWHPCOLOR = '4B0000'
	local HPBAROFFSETX = 4
	local HPBAROFFSETY = 4
	local PATIENTHPLENGTH = 92
	local VIRUSHPLENGTH = 232

	_level.initqueue.queue(10,function(level,beat)

		local copied = false

		local function combinepath(path, file)
			return path .. '/' .. file
		end

		local function copyfile(srcpath, dstpath, filename)
			local srcfilename = combinepath(srcpath, filename)
			local srcfile = io.open(srcfilename, 'rb')

			local dstfilename = combinepath(dstpath, filename)
			local dstfile = io.open(dstfilename, 'wb')

			dstfile:write(srcfile:read('*all'))

			srcfile:close()
			dstfile:close()
		end

		local function copyfilesifrequired()
			if copied then return end

			copyfile(BOSSBARPATH, inlevel, 'patientbg.png')
			copyfile(BOSSBARPATH, inlevel, 'patientfg.png')
			copyfile(BOSSBARPATH, inlevel, 'patientmk.png')

			copyfile(BOSSBARPATH, inlevel, 'virusbg.png')
			copyfile(BOSSBARPATH, inlevel, 'virusfg.png')
			copyfile(BOSSBARPATH, inlevel, 'virusmk.png')

			copyfile(BOSSBARPATH, inlevel, 'bossbarhp.png')

			copied = true
		end

		local function runondeco(bar, func, ...)
			func(bar.bg, ...)
			func(bar.fg, ...)
			func(bar.hp, ...)
			func(bar.mk, ...)
		end

		local function rundecomethod(onpatient, onvirus, bars, method, ...)
			if onpatient then
				bars.patient.bg[method](bars.patient.bg, ...)
				bars.patient.fg[method](bars.patient.fg, ...)
				bars.patient.hp[method](bars.patient.hp, ...)
				bars.patient.mk[method](bars.patient.mk, ...)
			end
			if onvirus then
				bars.virus.bg[method](bars.virus.bg, ...)
				bars.virus.fg[method](bars.virus.fg, ...)
				bars.virus.hp[method](bars.virus.hp, ...)
				bars.virus.mk[method](bars.virus.mk, ...)
			end
		end

		local function makebar(prefix, x, y, color, hplength)
			local bar = {}

			bar.bg = level:newdecoration(prefix .. 'bg.png', BOSSBARDEPTH + 1, 0)
			bar.fg = level:newdecoration(prefix .. 'fg.png', BOSSBARDEPTH - 1, 0)
			bar.mk = level:newdecoration(prefix .. 'mk.png', BOSSBARDEPTH - 2, 0)
			bar.hp = level:newdecoration('bossbarhp.png', BOSSBARDEPTH, 0)

			local oldmovex = bar.hp.movex
			bar.hp.movex = function(self, beat, v, ...)
				v = v + HPBAROFFSETX / 3.52
				oldmovex(self, beat, v, ...)
			end

			local oldmovey = bar.hp.movey
			bar.hp.movey = function(self, beat, v, ...)
				v = v - 2
				oldmovey(self, beat, v, ...)
			end

			runondeco(bar, bar.bg.setvisibleatstart, false)
			runondeco(bar, bar.bg.move, 0, {x = x, y = y, px = 0, py = 100}, 0, 'Linear')
			bar.hp:movesx(0, hplength, 0, 'Linear')

			bar.hp:settint(0, true, color, 100, 0, 'Linear')

			return bar
		end

		level.bossbars = {}
		
		function level:newbossbar(room, patienthp, virushp, gameoverbar, hpflash, hpeaseduration, hpease, patienthpvar, virushpvar)
			checkvar_room(room, 'room')
			checkvar_type(patienthp, 'patienthp', 'number')
			checkvar_type(virushp, 'virushp', 'number')
			checkvar_type(gameoverbar, 'gameoverbar', 'number')
			checkvar_type(hpflash, 'hpflash', 'number', true)
			checkvar_type(hpeaseduration, 'hpeaseduration', 'number', true)
			checkvar_enum(hpease, 'hpease', enums.ease, true)
			checkvar_rdcodevar(patienthpvar, 'patienthpvar', 'float', true)
			checkvar_rdcodevar(virushpvar, 'virushpvar', 'float', true)

			hpeaseduration = hpeaseduration or 1
			hpease = hpease or 'OutCubic'
			hpflash = hpflash or 0.5
			patienthpvar = patienthpvar or 'f0'
			virushpvar = virushpvar or 'f1'

			level:rdcode(0, patienthpvar .. ' = ' .. patienthp)
			level:rdcode(0, virushpvar .. ' = ' .. virushp)

			local prefix = 'dn.bossbar(' .. room .. ')'
			local onmiss = '[onMiss]dn.bossbar(' .. room .. ')'
			local onhit = '[onHit]dn.bossbar(' .. room .. ')'

			local function setpatienthpstate(beat, state)
				local action = state and 'EnableTag(' or 'DisableTag('
				level:rdcode(beat, action .. '"' .. onmiss .. '"' .. ')')
			end

			local function setvirushpstate(beat, state)
				local action = state and 'EnableTag(' or 'DisableTag('
				level:rdcode(beat, action .. '"' .. onhit .. '"' .. ')')
			end

			local function adjustpos(self, beat, duration, ease)
				local patientoffsety = VIRUSBAROFFSETY
				if getvalue(self, 'virusenabled', beat) then
					patientoffsety = VIRUSBAROFFSETY + PATIENTBAROFFSETY
					rundecomethod(false, true, self, 'movey', beat, VIRUSBAROFFSETY, duration, ease)
				end

				if getvalue(self, 'patientenabled', beat) then
					rundecomethod(true, false, self, 'movey', beat, patientoffsety, duration, ease)
				end
			end

			setpatienthpstate(0, false)
			setvirushpstate(0, false)

			local bars = {}
			bars.objecttype = 'bossbar'
			bars.level = self

			bars.patient = makebar(PATIENTPREFIX, VIRUSBAROFFSETX + PATIENTBAROFFSETX, PATIENTBAROFFSETY, PATIENTBARCOLOR, PATIENTHPLENGTH)
			bars.virus = makebar(VIRUSPREFIX, VIRUSBAROFFSETX, VIRUSBAROFFSETY, VIRUSBARCOLOR, VIRUSHPLENGTH)

			bars.values = {
				room = {{beat = 0, state = room}},
				virusenabled = {{beat = 0, state = true}},
				patientenabled = {{beat = 0, state = true}},
				enabled = {{beat = 0, state = false}}
			}

			function bars:setroom(beat, room)
				checkvar_type(beat, 'beat', 'number')
				checkvar_room(room, 'room')

				if beat == 0 then beat = 0.01 end -- don't allow on the first beat to avoid merging with start events

				setvalue(self, 'room', beat, room)
				rundecomethod(bars, 'setroom', beat, room)
			end

			function bars:setpatientstate(beat, state)
				checkvar_type(beat, 'beat', 'number')
				checkvar_type(state, 'state', 'boolean')

				if beat == 0 then beat = 0.01 end -- don't allow on the first beat to avoid merging with start events

				setvalue(self, 'patientenabled', beat, state)
				setpatienthpstate(beat, state)

				local method = state and 'show' or 'hide'
				if getvalue(self, 'enabled', beat) then
					rundecomethod(true, false, bars, method, beat)
				end
			end

			function bars:setvirusstate(beat, state)
				checkvar_type(beat, 'beat', 'number')
				checkvar_type(state, 'state', 'boolean')

				if beat == 0 then beat = 0.01 end -- don't allow on the first beat to avoid merging with start events

				setvalue(self, 'virusenabled', beat, state)
				setvirushpstate(beat, state)

				local method = state and 'show' or 'hide'
				if getvalue(self, 'enabled', beat) then
					rundecomethod(false, true, bars, method, beat)
				end
			end

			function bars:setstate(beat, state)
				checkvar_type(beat, 'beat', 'number')
				checkvar_type(state, 'state', 'boolean')

				if beat == 0 then beat = 0.01 end -- don't allow on the first beat to avoid merging with start events

				setvalue(self, 'enabled', beat, state)

				local method = state and 'show' or 'hide'
				if getvalue(self, 'patientenabled', beat) then
					rundecomethod(true, false, bars, method, beat)
					setpatienthpstate(beat, state)
				end

				if getvalue(self, 'virusenabled', beat) then
					rundecomethod(false, true, bars, method, beat)
					setvirushpstate(beat, state)
				end
			end

			function bars:show(beat, duration, ease)
				checkvar_type(beat, 'beat', 'number')
				checkvar_type(duration, 'duration', 'number', true)
				checkvar_enum(ease, 'ease', enums.ease, true)

				if beat == 0 then beat = 0.01 end -- don't allow on the first beat to avoid merging with start events

				duration = duration or 0
				ease = ease or 'Linear'

				bars:setstate(beat, true)

				local patientoffsety = VIRUSBAROFFSETY

				if getvalue(self, 'virusenabled', beat) then
					patientoffsety = VIRUSBAROFFSETY + PATIENTBAROFFSETY

					rundecomethod(false, true, bars, 'move', beat, {
						x = VIRUSBAROFFSETX,
						y = VIRUSBAROFFSETY + DISABLEDOFFSETY
					}, 0, 'Linear')
				end

				if getvalue(self, 'patientenabled', beat) then
					rundecomethod(true, false, bars, 'move', beat, {
						x = VIRUSBAROFFSETX + PATIENTBAROFFSETX,
						y = patientoffsety + DISABLEDOFFSETY
					}, 0, 'Linear')
				end

				adjustpos(bars, beat, duration, ease)
			end

			function bars:hide(beat, duration, ease)
				checkvar_type(beat, 'beat', 'number')
				checkvar_type(duration, 'duration', 'number', true)
				checkvar_enum(ease, 'ease', enums.ease, true)

				if beat == 0 then beat = 0.01 end -- don't allow on the first beat to avoid merging with start events

				duration = duration or 0
				ease = ease or 'Linear'

				bars:setstate(beat + duration, false)

				local patientoffsety = VIRUSBAROFFSETY

				if getvalue(self, 'virusenabled', beat) then
					patientoffsety = VIRUSBAROFFSETY + PATIENTBAROFFSETY

					rundecomethod(false, true, bars, 'move', beat, {
						x = VIRUSBAROFFSETX,
						y = VIRUSBAROFFSETY
					}, 0, 'Linear')
				end

				if getvalue(self, 'patientenabled', beat) then
					rundecomethod(true, false, bars, 'move', beat, {
						x = VIRUSBAROFFSETX + PATIENTBAROFFSETX,
						y = patientoffsety
					}, 0, 'Linear')
				end

				adjustpos(self, beat, duration, ease)
			end

			function bars:adjustposition(beat, duration, ease)
				checkvar_type(beat, 'beat', 'number')
				checkvar_type(duration, 'duration', 'number', true)
				checkvar_enum(ease, 'ease', enums.ease, true)

				duration = duration or 0
				ease = ease or 'Linear'

				adjustpos(self, beat, duration, ease)
			end
			
			local stillalivecond = level:customconditional(prefix .. '.stillalive', patienthpvar .. ' > 0')
			stillalivecond:red(true)
			local patienthpatleast0 = level:customconditional(prefix .. '.patientnegative', patienthpvar .. ' < 0')
			patienthpatleast0:red(true)
			local virushpatleast0 = level:customconditional(prefix .. '.virusnegative', virushpvar .. ' < 0')
			virushpatleast0:red(true)
			local patienthplow = level:customconditional(prefix .. '.patientlow', patienthpvar .. ' < 0.3')
			local virushplow = level:customconditional(prefix .. '.viruslow', virushpvar .. ' < 0.3')

			local repeater = prefix .. '.repeat'
			level:tag(repeater, function()
				level:conditional(patienthplow, 0)
				bars.patient.bg:settint(2, true, LOWHPCOLOR, 50, 0, 'Linear')
				bars.patient.fg:settint(2, true, LOWHPCOLOR, 50, 0, 'Linear')
				bars.patient.bg:settint(2 + hpflash, false, 'FFFFFF', 100, 0, 'Linear')
				bars.patient.fg:settint(2 + hpflash, false, 'FFFFFF', 100, 0, 'Linear')

				level:conditional(virushplow, 0)
				bars.virus.bg:settint(2, true, LOWHPCOLOR, 50, 0, 'Linear')
				bars.virus.fg:settint(2, true, LOWHPCOLOR, 50, 0, 'Linear')
				bars.virus.bg:settint(2 + hpflash, false, 'FFFFFF', 100, 0, 'Linear')
				bars.virus.fg:settint(2 + hpflash, false, 'FFFFFF', 100, 0, 'Linear')

				level:endconditional()
				level:runtag(2 + 2*hpflash, repeater)
			end)
			level:runtag(0.01, repeater)

			level:tag(onmiss, function()
				level:rdcode(1, patienthpvar .. ' = ' .. patienthpvar .. ' - 1', 'OnPreBar', -1000)

				level:conditional(patienthpatleast0, 0)
				bars.patient.hp:movesx(1, '{' .. patienthpvar .. '/' .. patienthp .. '*' .. PATIENTHPLENGTH .. '}', hpeaseduration, hpease)
				bars.patient.hp:settint(1, true, 'FFFFFF', 100, 0, 'Linear')
				bars.patient.hp:settint(1 + hpflash, true, PATIENTBARCOLOR, 100, 0, 'Linear')

				level:conditional(stillalivecond, 0)
				level:rdcode(1, 'SetNextBarExtraImmediately(' .. gameoverbar .. ')', nil, 1)

				level:endconditional()
			end)

			level:tag(onhit, function()
				level:rdcode(1, virushpvar .. ' = ' .. virushpvar .. ' - 1', 'OnPreBar', -1000)

				level:conditional(virushpatleast0, 0)
				bars.virus.hp:movesx(1, '{' .. virushpvar .. '/' .. virushp .. '*' .. VIRUSHPLENGTH .. '}', hpeaseduration, hpease)
				bars.virus.hp:settint(1, true, 'FFFFFF', 100, 0, 'Linear')
				bars.virus.hp:settint(1 + hpflash, true, VIRUSBARCOLOR, 100, 0, 'Linear')

				level:endconditional()
			end)

			copyfilesifrequired()

			level.bossbars[room] = bars
			return bars
		end

		function level:getbossbar(room)
			checkvar_type(room, 'room', 'number')
			return level.bossbars[room]
		end
	
		--if you need to initialize anything, do it here.

		
		
		
		-- fake event handlers
		
		--add event type condensers
		
	end)
end

return extension