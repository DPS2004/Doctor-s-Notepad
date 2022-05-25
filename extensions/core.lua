local extension = function(_level)
	_level.initqueue.queue(0,function(level,beat) --the number is in what order your extension will be loaded. lower = sooner
		
		--all of the functions you are adding to the level table go up here
	
		-- cues

		function level:cue(beat, ctype, tick)
			ctype = ctype or "SayGetSetGo"
			tick = tick or 1
			self:addevent(beat, "SayReadyGetSetGo", {phraseToSay = ctype, tick = tick, voiceSource = "Nurse", volume = 100})
		end

		--custom methods

		function level:rdcode(beat, code,extime)
			beat = beat or 0
			extime = extime or "OnBar"
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
		
		--end level
		function level:finish(beat,delay)
			if delay then
				for i=0,2 do
					self:addevent(beat+i*delay,'FinishLevel')
				end
			else
				self:addevent(beat,'FinishLevel')
			end
		end

	
		--if you need to initialize anything, do it here.

		
		
		
		-- fake event handlers
		
	
	end)
end

return extension