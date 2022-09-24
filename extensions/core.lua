local extension = function(_level)
	_level.initqueue.queue(0,function(level,beat) --the number is in what order your extension will be loaded. lower = sooner
		
		--all of the functions you are adding to the level table go up here

		--custom methods

		function level:rdcode(beat, code, extime, sortoffset)
			beat = beat or 0
			extime = extime or "OnBar"
			sortoffset = sortoffset or 0
			self:addevent(beat, "CallCustomMethod", {methodName = code, executionTime = extime, sortOffset = sortoffset})
		end
		
		function level:runtag(beat, tag)
			beat = beat or 0
			self:addevent(beat, "TagAction", {Action = 'Run', Tag = tag})
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
		
		--dialog
		function level:dialog(beat,text,sounds,panel,portrait,speed)
			speed = speed or 1 --speed currently has no effect :(
			if sounds == nil then sounds = true end
			panel = panel or 'Bottom'
			portrait = portrait or 'Left'
			self:addevent(beat, "ShowDialogue", {text = text, panelSide = panel, portraitSide = portrait, speed = speed, playTextSounds = sounds})
		end
		
		function level:hidedialog(beat)
			level:dialog(beat,'',false)
		end
		
		--comments
		function level:showcomments()
			self.doshowcomments = true
		end
		
		--bruh
		level.dialogue = level.dialog
		level.hidedialogue = level.hidedialog
		--comments
		
		
		function level:comment(beat, text)
			self:addevent(beat, "Comment", {show = self.doshowcomments, text=text})
		end
		
		
		function level:speed(beat, speed, dmult)
			self:addevent(beat, "SetSpeed", {speed = speed})
			if dmult then
				self:durationmult(speed)
			end
		end
		
	
		function level:showcomments()
			self.doshowcomments = true
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

		level.doshowcomments = false
		
		
		-- fake event handlers
		
	
	end)
end

return extension