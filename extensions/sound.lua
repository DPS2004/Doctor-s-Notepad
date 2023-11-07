local extension = function(_level)
	_level.initqueue.queue(5, function(level,beat) --the number is in what order your extension will be loaded. lower = sooner

		create_enum('cuetype', {
			'SayReaDyGetSetGoNew', 'SayGetSetGo', 'SayReaDyGetSetOne', 'SayGetSetOne', 'SayReadyGetSetGo', 'JustSayReady',
			'JustSayRea', 'JustSayAnd', 'JustSayStop', 'JustSayDy', 'JustSayGo', 'JustSayAndStop', 'JustSayGet', 'JustSaySet',
			'Count1', 'Count2', 'Count3', 'Count4', 'Count5'
		})

		create_enum('cuevoice', {'Nurse', 'NurseTired', 'IanExcited', 'IanCalm', 'IanSlow', 'NoneBottom', 'NoneTop'})

		create_enum('voicesource', {
			'JyiCount', 'JyiCountFast', 'JyiCountTired', 'JyiCountVeryTired', 'JyiCountJapanese', 'JyiCountLegacy',
			'IanCount', 'IanCountFast', 'IanCountCalm', 'IanCountSlow', 'IanCountSlower',
			'BirdCount', 'OwlCount', 'WhistleCount'
		})

		create_enum('beatsound', {
			'None', 'Shaker', 'ShakerHi', 'Stick', 'StickOld', 'Sidestick', 'Punch', 'Ride2',
			'Kick', 'KickChroma', 'KickClean', 'KickTight', 'KickHouse', 'KickRupture', 'KickEcho',
			'Hammer', 'Chuck', 'ClosedHat', 'HatTight', 'HatHouse', 'Sizzle', 'ClavesLow', 'ClavesHigh',
			'TomLowE', 'TomMidG', 'TomMidB', 'TomHighD', 'WoodblockHigh', 'WoodblockLow', 'TriangleMute', 'Cowbell'
		})

		create_enum('playsoundtype', {'CueSound', 'MusicSound', 'BeatSound', 'HitSound', 'OtherSound'})

		create_enum('heartexplosioninterval', {'OneBeatAfter', 'Instant', 'GatherNoCeil', 'GatherAndCeil'})

		create_enum('rowtype', {'Classic', 'Oneshot'})

		create_enum('clapsound', {
			'ClapHit', 'ClapHitP2', 'ClapHitCPU', 'ReverbClap', 'ClapHitMassivePreEcho', 'ClapHitEcho',
			'SnareAcoustic2', 'SnareAcoustic4', 'SnareHouse', 'SnareVapor'
		})

		create_enum('gamesound', {
			'SmallMistake', 'BigMistake',
			'Hand1PopSound', 'Hand2PopSound',
			'HeartExplosion', 'HeartExplosion2', 'HeartExplosion3'
		})

		create_enum('voicesource_oneshot', {'JyiCount', 'IanCountEnglish', 'IanCountEnglishFast', 'IanCountEnglishCalm'})
		
		--all of the functions you are adding to the level table go up here

		function level:cue(beat, ctype, voice, volume, tick)
			checkvar_type(beat, 'beat', 'number')
			checkvar_type(tick, 'tick', 'number', true)
			checkvar_type(volume, 'volume', 'number', true)
			checkvar_enum(ctype, 'ctype', enums.cuetype)
			checkvar_enum(voice, 'voice', enums.cuevoice)

			tick = tick or 1
			volume = volume or 100

			self:addevent(beat, "SayReadyGetSetGo", {phraseToSay = ctype, tick = tick, voiceSource = voice, volume = volume})
		end


		function level:setbpm(beat, bpm)
			checkvar_type(beat, 'beat', 'number')
			checkvar_type(bpm, 'bpm', 'number')

			beat = beat or 0
			bpm = bpm or 100

			self:addevent(beat, "SetBeatsPerMinute", {beatsPerMinute = bpm})

		end
		
		function level:playsound(beat, sound, volume, pitch, pan, offset, soundtype)
			checkvar_type(beat, 'beat', 'number')
			checkvar_type(sound, 'sound', 'string')
			checkvar_enum(soundtype, 'soundtype', enums.playsoundtype, true)
			checkvar_type(volume, 'volume', 'number', true)
			checkvar_type(pitch, 'pitch', 'number', true)
			checkvar_type(pan, 'pan', 'number', true)
			checkvar_type(offset, 'offset', 'number', true)

			volume = volume or 100
			pitch = pitch or 100
			pan = pan or 0
			offset = offset or 0
			soundtype = soundtype or "CueSound"

			self:addevent(beat, "PlaySound", {sound = {filename = sound, volume = volume, pitch = pitch, pan = pan, offset = offset}, isCustom = true, customSoundType = soundtype })

		end

		function level:setclapsounds(beat, rowtype, p1sound, p1volume, p1pitch, p1pan, p1offset, p2sound, p2volume, p2pitch, p2pan, p2offset, cpusound, cpuvolume, cpupitch, cpupan, cpuoffset, p1used, p2used, cpuused)
			checkvar_type(beat, 'beat', 'number')
			checkvar_enum(rowtype, 'rowtype', enum.rowtype)
			checkvar_type(p1used, 'p1used', 'boolean')
			checkvar_type(p2used, 'p2used', 'boolean')
			checkvar_type(cpuused, 'cpuused', 'boolean')

			if p1used then
				checkvar_enum(p1sound, 'p1sound', enum.clapsound)
				checkvar_type(p1volume, 'p1volume', 'number', true)
				checkvar_type(p1pitch, 'p1pitch', 'number', true)
				checkvar_type(p1pan, 'p1pan', 'number', true)
				checkvar_type(p1offset, 'p1offset', 'number', true)

				p1volume = p1volume or 100
				p1pitch = p1pitch or 100
				p1pan = p1pan or 0
				p1offset = p1offset or 0
			end

			if p2used then
				checkvar_enum(p2sound, 'p2sound', enum.clapsound)
				checkvar_type(p2volume, 'p2volume', 'number', true)
				checkvar_type(p2pitch, 'p2pitch', 'number', true)
				checkvar_type(p2pan, 'p2pan', 'number', true)
				checkvar_type(p2offset, 'p2offset', 'number', true)

				p2volume = p2volume or 100
				p2pitch = p2pitch or 100
				p2pan = p2pan or 0
				p2offset = p2offset or 0
			end

			if cpuused then
				checkvar_enum(cpusound, 'cpusound', enum.clapsound)
				checkvar_type(cpuvolume, 'cpuvolume', 'number', true)
				checkvar_type(cpupitch, 'cpupitch', 'number', true)
				checkvar_type(cpupan, 'cpupan', 'number', true)
				checkvar_type(cpuoffset, 'cpuoffset', 'number', true)

				cpuvolume = cpuvolume or 100
				cpupitch = cpupitch or 100
				cpupan = cpupan or 0
				cpuoffset = cpuoffset or 0
			end

			-- god
			self:addevent(beat, "SetClapSounds", {
				rowType = rowtype,
				p1Sound = p1used and {
					filename = p1sound, volume = p1volume, pitch = p1pitch, pan = p1pan, offset = p1offset
				} or DN_NULL,
				p2Sound = p2used and {
					filename = p2sound, volume = p2volume, pitch = p2pitch, pan = p2pan, offset = p2offset
				} or DN_NULL,
				cpuSound = cpuused and {
					filename = cpusound, volume = cpuvolume, pitch = cpupitch, pan = cpupan, offset = cpuoffset
				} or DN_NULL
			})

		end

		function level:heartexplosioninterval(beat, intervaltype, interval)
			checkvar_type(beat, 'beat', 'number')
			checkvar_type(interval, 'interval', 'number')
			checkvar_enum(intervaltype, 'intervaltype', enum.heartexplosioninterval)

			self:addevent(beat, "SetHeartExplodeInterval", {intervalType = intervaltype, interval = interval})

		end

		function level:setgamesound(beat, soundtype, filename, volume, pitch, pan)
			checkvar_type(beat, 'beat', 'number')
			checkvar_enum(soundtype, 'soundtype', enum.gamesound)
			checkvar_type(filename, 'filename', 'string')
			checkvar_type(volume, 'volume', 'number', true)
			checkvar_type(pitch, 'pitch', 'number', true)
			checkvar_type(pan, 'pan', 'number', true)

			volume = volume or 100
			pitch = pitch or 100
			pan = pan or 0

			self:addevent(beat, 'SetGameSound', {soundType = soundtype, filename = filename, volume = volume, pitch = pitch, pan = pan, offset = 0})

		end

		function level:setbeatsound(beat, row, filename, volume, pitch, pan)
			checkvar_type(beat, 'beat', 'number')
			checkvar_type(row, 'row', 'number')
			checkvar_enum(filename, 'filename', enums.beatsound)
			checkvar_type(volume, 'volume', 'number', true)
			checkvar_type(pitch, 'pitch', 'number', true)
			checkvar_type(pan, 'pan', 'number', true)

			volume = volume or 100
			pitch = pitch or 100
			pan = pan or 0

			-- volume doesn't seem to be set correctly when loading in RD (set to 100%) even though it's set in the rdlevel file?
			self:addevent(beat, 'SetBeatSound', {row = row, sound = {filename = filename, volume = volume, pitch = pitch, pan = pan, offset = 0}})

		end

		function level:setcountingsound(beat, row, voicesource, enabled, volume)
			checkvar_type(beat, 'beat', 'number')
			checkvar_type(row, 'row', 'number')
			checkvar_enum(voicesource, 'voicesource', enums.voicesource, true)
			checkvar_type(enabled, 'enabled', 'boolean', true)
			checkvar_type(volume, 'volume', 'number', true)

			voicesource = voicesource or 'JyiCount'
			enabled = not not enabled
			volume = volume or 100

			self:addevent(beat, 'SetCountingSound', {row = row, voiceSource = voicesource, enabled = enabled, volume = volume})

		end

		function level:setoneshotcountingsound(beat, row, voicesource, enabled, volume, subdivoffset)
			checkvar_type(beat, 'beat', 'number')
			checkvar_type(row, 'row', 'number')
			checkvar_enum(voicesource, 'voicesource', enum.voicesource_oneshot, true)
			checkvar_type(enabled, 'enabled', 'boolean', true)
			checkvar_type(volume, 'volume', 'number', true)
			checkvar_type(subdivoffset, 'subdivoffset', 'number', true)

			voicesource = voicesource or 'JyiCount'
			enabled = not not enabled
			volume = volume or 100
			subdivoffset = subdivoffset or 0.5

			self:addevent(beat, 'SetCountingSound', {row = row, voiceSource = voicesource, enabled = enabled, volume = volume, subdivOffset = subdivoffset})
		end
		
		--add event type condensers

		-- none for sounds :relieved:
		
	end)
end

return extension