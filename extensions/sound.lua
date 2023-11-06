local extension = function(_level)
	_level.initqueue.queue(5, function(level,beat) --the number is in what order your extension will be loaded. lower = sooner

		local ENUM_CUETYPE = {
			SayReaDyGetSetGoNew = true, SayGetSetGo = true, SayReaDyGetSetOne = true, SayGetSetOne = true, SayReadyGetSetGo = true, JustSayReady = true,
			JustSayRea = true, JustSayAnd = true, JustSayStop = true, JustSayDy = true, JustSayGo = true, JustSayAndStop = true, JustSayGet = true, JustSaySet = true,
			Count1 = true, Count2 = true, Count3 = true, Count4 = true, Count5 = true
		}

		local ENUM_CUEVOICE = {
			Nurse = true, NurseTired = true,
			IanExcited = true, IanCalm = true, IanSlow = true,
			NoneBottom = true, NoneTop = true
		}

		local ENUM_VOICESOURCE = {
			JyiCount = true, JyiCountFast = true, JyiCountTired = true, JyiCountVeryTired = true, JyiCountJapanese = true, JyiCountLegacy = true,
			IanCount = true, IanCountFast = true, IanCountCalm = true, IanCountSlow = true, IanCountSlower = true,
			BirdCount = true, OwlCount = true, WhistleCount = true
		}

		local ENUM_BEATSOUND = {
			None = true, Shaker = true, ShakerHi = true, Stick = true, StickOld = true, Sidestick = true, Punch = true, Ride2 = true,
			Kick = true, KickChroma = true, KickClean = true, KickTight = true, KickHouse = true, KickRupture = true, KickEcho = true,
			Hammer = true, Chuck = true, ClosedHat = true, HatTight = true, HatHouse = true, Sizzle = true, ClavesLow = true, ClavesHigh = true,
			TomLowE = true, TomMidG = true, TomMidB = true, TomHighD = true, WoodblockHigh = true, WoodblockLow = true, TriangleMute = true, Cowbell = true
		}

		local ENUM_PLAYSOUNDTYPE = {
			CueSound = true, MusicSound = true, BeatSound = true, HitSound = true, OtherSound = true
		}

		local ENUM_HEARTEXPLOSIONINTERVAL = {
			OneBeatAfter = true, Instant = true, GatherNoCeil = true, GatherAndCeil = true
		}

		local ENUM_ROWTYPE = {
			Classic = true, Oneshot = true
		}

		local ENUM_CLAPSOUND = {
			ClapHit = true, ClapHitP2 = true, ClapHitCPU = true, ReverbClap = true, ClapHitMassivePreEcho = true, ClapHitEcho = true,
			SnareAcoustic2 = true, SnareAcoustic4 = true, SnareHouse = true, SnareVapor = true
		}

		local ENUM_GAMESOUND = {
			SmallMistake = true, BigMistake = true,
			Hand1PopSound = true, Hand2PopSound = true,
			HeartExplosion = true, HeartExplosion2 = true, HeartExplosion3 = true
		}

		local ENUM_ONESHOT_VOICESOURCE = {
			JyiCount = true,
			IanCountEnglish = true, IanCountEnglishFast = true, IanCountEnglishCalm = true
		}
		
		--all of the functions you are adding to the level table go up here

		function level:cue(beat, ctype, voice, volume, tick)
			level:checkvar_type(beat, 'beat', 'number')
			level:checkvar_type(tick, 'tick', 'number', true)
			level:checkvar_type(volume, 'volume', 'number', true)
			level:checkvar_enum(ctype, 'ctype', ENUM_CUETYPE)
			level:checkvar_enum(voice, 'voice', ENUM_CUEVOICE)

			tick = tick or 1
			volume = volume or 100

			self:addevent(beat, "SayReadyGetSetGo", {phraseToSay = ctype, tick = tick, voiceSource = voice, volume = volume})
		end


		function level:setbpm(beat, bpm)
			level:checkvar_type(beat, 'beat', 'number')
			level:checkvar_type(bpm, 'bpm', 'number')

			beat = beat or 0
			bpm = bpm or 100

			self:addevent(beat, "SetBeatsPerMinute", {beatsPerMinute = bpm})

		end
		
		function level:playsound(beat, sound, volume, pitch, pan, offset, soundtype)
			level:checkvar_type(beat, 'beat', 'number')
			level:checkvar_type(sound, 'sound', 'string')
			level:checkvar_enum(soundtype, 'soundtype', ENUM_PLAYSOUNDTYPE, true)
			level:checkvar_type(volume, 'volume', 'number', true)
			level:checkvar_type(pitch, 'pitch', 'number', true)
			level:checkvar_type(pan, 'pan', 'number', true)
			level:checkvar_type(offset, 'offset', 'number', true)

			volume = volume or 100
			pitch = pitch or 100
			pan = pan or 0
			offset = offset or 0
			soundtype = soundtype or "CueSound"

			self:addevent(beat, "PlaySound", {sound = {filename = sound, volume = volume, pitch = pitch, pan = pan, offset = offset}, isCustom = true, customSoundType = soundtype })

		end

		function level:setclapsounds(beat, rowtype, p1sound, p1volume, p1pitch, p1pan, p1offset, p2sound, p2volume, p2pitch, p2pan, p2offset, cpusound, cpuvolume, cpupitch, cpupan, cpuoffset, p1used, p2used, cpuused)
			level:checkvar_type(beat, 'beat', 'number')
			level:checkvar_enum(rowtype, 'rowtype', ENUM_ROWTYPE)
			level:checkvar_type(p1used, 'p1used', 'boolean')
			level:checkvar_type(p2used, 'p2used', 'boolean')
			level:checkvar_type(cpuused, 'cpuused', 'boolean')

			if p1used then
				level:checkvar_enum(p1sound, 'p1sound', ENUM_CLAPSOUND)
				level:checkvar_type(p1volume, 'p1volume', 'number', true)
				level:checkvar_type(p1pitch, 'p1pitch', 'number', true)
				level:checkvar_type(p1pan, 'p1pan', 'number', true)
				level:checkvar_type(p1offset, 'p1offset', 'number', true)

				p1volume = p1volume or 100
				p1pitch = p1pitch or 100
				p1pan = p1pan or 0
				p1offset = p1offset or 0
			end

			if p2used then
				level:checkvar_enum(p2sound, 'p2sound', ENUM_CLAPSOUND)
				level:checkvar_type(p2volume, 'p2volume', 'number', true)
				level:checkvar_type(p2pitch, 'p2pitch', 'number', true)
				level:checkvar_type(p2pan, 'p2pan', 'number', true)
				level:checkvar_type(p2offset, 'p2offset', 'number', true)

				p2volume = p2volume or 100
				p2pitch = p2pitch or 100
				p2pan = p2pan or 0
				p2offset = p2offset or 0
			end

			if cpuused then
				level:checkvar_enum(cpusound, 'cpusound', ENUM_CLAPSOUND)
				level:checkvar_type(cpuvolume, 'cpuvolume', 'number', true)
				level:checkvar_type(cpupitch, 'cpupitch', 'number', true)
				level:checkvar_type(cpupan, 'cpupan', 'number', true)
				level:checkvar_type(cpuoffset, 'cpuoffset', 'number', true)

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
			level:checkvar_type(beat, 'beat', 'number')
			level:checkvar_type(interval, 'interval', 'number')
			level:checkvar_enum(intervaltype, 'intervaltype', ENUM_HEARTEXPLOSIONINTERVAL)

			self:addevent(beat, "SetHeartExplodeInterval", {intervalType = intervaltype, interval = interval})

		end

		function level:setgamesound(beat, soundtype, filename, volume, pitch, pan)
			level:checkvar_type(beat, 'beat', 'number')
			level:checkvar_enum(soundtype, 'soundtype', ENUM_GAMESOUND)
			level:checkvar_type(filename, 'filename', 'string')
			level:checkvar_type(volume, 'volume', 'number', true)
			level:checkvar_type(pitch, 'pitch', 'number', true)
			level:checkvar_type(pan, 'pan', 'number', true)

			volume = volume or 100
			pitch = pitch or 100
			pan = pan or 0

			self:addevent(beat, 'SetGameSound', {soundType = soundtype, filename = filename, volume = volume, pitch = pitch, pan = pan, offset = 0})

		end

		function level:setbeatsound(beat, row, filename, volume, pitch, pan)
			level:checkvar_type(beat, 'beat', 'number')
			level:checkvar_type(row, 'row', 'number')
			level:checkvar_enum(filename, 'filename', ENUM_BEATSOUND)
			level:checkvar_type(volume, 'volume', 'number', true)
			level:checkvar_type(pitch, 'pitch', 'number', true)
			level:checkvar_type(pan, 'pan', 'number', true)

			volume = volume or 100
			pitch = pitch or 100
			pan = pan or 0

			-- volume doesn't seem to be set correctly when loading in RD (set to 100%) even though it's set in the rdlevel file?
			self:addevent(beat, 'SetBeatSound', {row = row, sound = {filename = filename, volume = volume, pitch = pitch, pan = pan, offset = 0}})

		end

		function level:setcountingsound(beat, row, voicesource, enabled, volume)
			level:checkvar_type(beat, 'beat', 'number')
			level:checkvar_type(row, 'row', 'number')
			level:checkvar_enum(voicesource, 'voicesource', ENUM_VOICESOURCE, true)
			level:checkvar_type(enabled, 'enabled', 'boolean', true)
			level:checkvar_type(volume, 'volume', 'number', true)

			voicesource = voicesource or 'JyiCount'
			enabled = not not enabled
			volume = volume or 100

			self:addevent(beat, 'SetCountingSound', {row = row, voiceSource = voicesource, enabled = enabled, volume = volume})

		end

		function level:setoneshotcountingsound(beat, row, voicesource, enabled, volume, subdivoffset)
			level:checkvar_type(beat, 'beat', 'number')
			level:checkvar_type(row, 'row', 'number')
			level:checkvar_enum(voicesource, 'voicesource', ENUM_ONESHOT_VOICESOURCE, true)
			level:checkvar_type(enabled, 'enabled', 'boolean', true)
			level:checkvar_type(volume, 'volume', 'number', true)
			level:checkvar_type(subdivoffset, 'subdivoffset', 'number', true)

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