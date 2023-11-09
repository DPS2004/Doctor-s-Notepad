local extension = function(_level)
	_level.initqueue.queue(0,function(level,beat) --the number is in what order your extension will be loaded. lower = sooner
		
		--all of the functions you are adding to the level table go up here

		--custom methods

		function level:rdcode(beat, code, extime, sortoffset)
			checkvar_type(beat, 'beat', 'number')
			checkvar_type(code, 'code', 'string')
			checkvar_type(extime, 'extime', 'string', true)
			checkvar_type(sortoffset, 'sortoffset', 'number', true)

			extime = extime or "OnBar"
			sortoffset = sortoffset or 0

			self:addevent(beat, "CallCustomMethod", {methodName = code, executionTime = extime, sortOffset = sortoffset})
		end
		
		function level:runtag(beat, tag)
			checkvar_type(beat, 'beat', 'number')
			checkvar_type(tag, 'tag', 'string')

			self:addevent(beat, "TagAction", {Action = 'Run', Tag = tag})
		end
		
		--dialog
		function level:dialog(beat,text,sounds,panel,portrait,speed)
			checkvar_type(beat, 'beat', 'number')
			checkvar_type(text, 'text', 'string')
			checkvar_type(sounds, 'sounds', 'boolean', true)
			checkvar_type(panel, 'panel', 'string', true)
			checkvar_type(portrait, 'portrait', 'string', true)
			checkvar_type(speed, 'speed', 'number', true)

			speed = speed or 1 --speed currently has no effect :(
			if sounds == nil then sounds = true end
			panel = panel or 'Bottom'
			portrait = portrait or 'Left'

			self:addevent(beat, "ShowDialogue", {text = text, panelSide = panel, portraitSide = portrait, speed = speed, playTextSounds = sounds})
		end
		
		function level:hidedialog(beat)
			checkvar_type(beat, 'beat', 'number')

			level:dialog(beat,'',false)
		end
		
		--bruh
		level.dialogue = level.dialog
		level.hidedialogue = level.hidedialog
		
		--comments
		function level:showcomments()
			self.doshowcomments = true
		end
		
		-- tabs can be "Actions", "Song", "Sprites" or "Rooms". defaults to "Actions"
		-- target is necessary if the tab is "Sprites"
		function level:comment(beat, text, color, tab, target)
			checkvar_type(beat, 'beat', 'number')
			checkvar_type(text, 'text', 'string')
			checkvar_color(color, 'color', true)
			checkvar_type(tab, 'tab', 'string', true)
			checkvar_type(target, 'target', 'string', true)

			color = color or "F2E644"
			tab = tab or "Actions"

			self:addevent(beat, "Comment", {show = self.doshowcomments, text=text, tab=tab, color=color, target=target})
		end
		
		function level:ccode(beat,text)
			checkvar_type(beat, 'beat', 'number')
			checkvar_type(text, 'text', 'string')
			self:addevent(beat, "Comment", {show = false, text="()=>"..text, tab="Actions", color="F2E644"})
		end
		
		function level:speed(beat, speed, dmult, ease, duration)
			checkvar_type(beat, 'beat', 'number')
			checkvar_type(speed, 'speed', 'number')
			checkvar_type(dmult, 'dmult', 'boolean', true)
			checkvar_enum(ease, 'ease', enums.ease, true)
			checkvar_type(duration, 'duration', 'number', true)

			self:addevent(beat, "SetSpeed", {speed = speed, ease = ease or "Linear", duration = duration or 0})
			if dmult then
				self:durationmult(speed)
			end
		end
		

		-- clear or keep every event that has the same type as any event in eventtypes
		function level:clearevents(eventtypes, keeplisted)
			checkvar_type(eventtypes, 'eventtypes', 'table')
			checkvar_type(keeplisted, 'keeplisted', 'boolean')

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
			checkvar_type(eventtypes, 'eventtypes', 'table')
			self:clearevents(eventtypes, true)
		end
		
		--end level
		function level:finish(beat,delay)
			checkvar_type(beat, 'beat', 'number')
			checkvar_type(delay, 'delay', 'number', true)

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
		
		function PX(x) 
			checkvar_type(x, 'x', 'number')
			return (x/352)*100
		end
		function PY(y)
			checkvar_type(y, 'y', 'number')
			return (y/198)*100
		end
		
		-- fake event handlers
		
	
	end)
end

return extension