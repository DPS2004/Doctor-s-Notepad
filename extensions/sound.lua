local extension = function(_level)
	_level.initqueue.queue(4,function(level,beat) --the number is in what order your extension will be loaded. lower = sooner
		
		--all of the functions you are adding to the level table go up here
		
		-- future notes for documentation

		-- ctype can be any of the below
		-- SayReaDyGetSetGoNew, SayGetSetGo, SayReaDyGetSetOne, SayGetSetOne, SayReadyGetSetGo, JustSayReady,
		-- JustSayRea, JustSayAnd, JustSayStop, JustSayDy, JustSayGo, JustSayAndStop, JustSayGet, JustSaySet,
		-- Count1, Count2, Count3, Count4, Count5

		-- voice can be any of the below
		-- Nurse, NurseTired, IanExcited, IanCalm, IanSlow, NoneBottom, NoneTop

		function level:cue(beat, ctype, voice, volume, tick)

			beat = beat or 0
			ctype = ctype or "SayGetSetGo"
			tick = tick or 1
			voice = voice or 'Nurse'
			volume = volume or 100

			self:addevent(beat, "SayReadyGetSetGo", {phraseToSay = ctype, tick = tick, voiceSource = voice, volume = volume})
		end


		function level:setbpm(beat, bpm)

			beat = beat or 0
			bpm = bpm or 100

			self:addevent(beat, "SetBeatsPerMinute", {beatsPerMinute = bpm})

		end


		-- soundtype can be any of the below
		-- CueSound, MusicSound, BeatSound, HitSound, OtherSound
		
		function level:playsound(beat, sound, volume, pitch, pan, offset, soundtype)

			volume = volume or 100
			pitch = pitch or 100
			pan = pan or 0
			offset = offset or 0
			soundtype = soundtype or "CueSound"

			self:addevent(beat, "PlaySound", {filename = sound, volume = volume, pitch = pitch, pan = pan, offset = offset, isCustom = true, customSoundType = soundtype })

		end


		-- p1sound, p2sound, cpusound can be any of the below
		-- ClapHit, ClapHitP2, ClapHitCPU, ReverbClap, ClapHitMassivePreEcho, ClapHitEcho,
		-- SnareAcoustic2, SnareAcoustic4, SnareHouse, SnareVapor

		-- oh boy i cant wait to document this

		function level:setclapsounds(beat, rowtype, p1sound, p1volume, p1pitch, p1pan, p1offset, p2sound, p2volume, p2pitch, p2pan, p2offset, cpusound, cpuvolume, cpupitch, cpupan, cpuoffset, p1used, p2used, cpuused)

			beat = beat or 0
			rowtype = rowtype or 'Classic' -- can also be 'Oneshot'

			p1sound = p1sound or 'ClapHit'
			p2sound = p2sound or 'ClapHitP2'
			cpusound = cpusound or 'ClapHitCPU'

			p1volume = p1volume or 100
			p2volume = p2volume or 100
			cpuvolume = cpuvolume or 100

			p1pitch = p1pitch or 100
			p2pitch = p2pitch or 100
			cpupitch = cpupitch or 100

			p1pan = p1pan or 0
			p2pan = p2pan or 0
			cpupan = cpupan or 0

			p1offset = p1offset or 0
			p2offset = p2offset or 0
			cpuoffset = cpuoffset or 0

			p1used = not not p1used
			p2used = not not p2used
			cpuused = not not cpuused

			-- god
			self:addevent(beat, "SetClapSounds", {
				rowType = rowtype, 
				p1Sound = p1sound,		p2Sound = p2sound,		cpuSound = cpusound,
				p1Volume = p1volume, 	p2Volume = p2volume,	cpuVolume = cpuvolume,
				p1Pitch = p1pitch,		p2Pitch = p2pitch,		cpuPitch = cpupitch,
				p1Pan = p1pan, 			p2Pan = p2pan,			cpuPan = cpupan,
				p1Offset = p1offset,	p2Offset = p2offset,	cpuOffset = cpuoffset,
				p1Used = p1used,		p2Used = p2used,		cpuUsed = cpuused
			})

		end


		-- intervaltype can be
		-- OneBeatAfter,	Instant,	GatherNoCeil,				GatherAndCeil

		-- Fixed Interval,	Instant,	Combine on Fixed Interval,	Combine on Downbeat
		-- ^ actual names in the event the hell why are they so different

		function level:heartexplosioninterval(beat, intervaltype, interval)

			beat = beat or 0
			intervaltype = intervaltype or 'OneBeatAfter'
			interval = interval or 0

			self:addevent(beat, "SetHeartExplodeInterval", {intervalType = intervaltype, interval = interval})

		end


		-- soundtype can be
		-- SmallMistake, BigMistake, Hand1PopSound, Hand2PopSound, HeartExplosion, HeartExplosion2, HeartExplosion3

		function level:setgamesound(beat, soundtype, filename, volume, pitch, pan)

			beat = beat or 0

			soundtype = soundtype or 'SmallMistake'
			filename = filename or ''

			volume = volume or 100
			pitch = pitch or 100
			pan = pan or 0

			self:addevent(beat, 'SetGameSound', {soundType = soundtype, filename = filename, volume = volume, pitch = pitch, pan = pan, offset = 0})

		end


		-- filename can be
		-- Shaker, None, ShakerHi, Stick, StickOld, Sidestick, Punch, Ride2,
		-- Kick, KickChroma, KickClean, KickTight, KickHouse, KickRupture, KickEcho,
		-- Hammer, Chuck, ClosedHat, HatTight, HatHouse, Sizzle, ClavesLow, ClavesHigh,
		-- TomLowE, TomMidG, TomMidB, TomHighD, WoodblockHigh, WoodblockLow, TriangleMute, Cowbell

		function level:setbeatsound(beat, row, filename, volume, pitch, pan)

			beat = beat or 0

			row = row or 0
			filename = filename or 'Shaker'
			volume = volume or 100
			pitch = pitch or 100
			pan = pan or 0

			-- volume doesn't seem to be set correctly when loading in RD (set to 100%) even though it's set in the rdlevel file?
			self:addevent(beat, 'SetBeatSound', {row = row, filename = filename, volume = volume, pitch = pitch, pan = pan})

		end


		-- voicesource can be
		-- JyiCount, JyiCountFast, JyiCountTired, JyiCountVeryTired, JyiCountJapanese,
		-- IanCount, IanCountFast, IanCountCalm, IanCountSlow, IanCountSlower,
		-- BirdCount, OwlCount, WhistleCount, JyiCountLegacy

		function level:setcountingsound(beat, row, voicesource, enabled, volume)

			beat = beat or 0

			row = row or 0
			voicesource = voicesource or 'JyiCount'
			enabled = not not enabled
			volume = volume or 100

			self:addevent(beat, 'SetCountingSound', {row = row, voiceSource = voicesource, enabled = enabled, volume = volume})

		end
		
		--add event type condensers

		-- none for sounds :relieved:
		
	end)
end

return extension