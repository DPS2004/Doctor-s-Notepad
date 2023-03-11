local extension = function(_level)
	_level.initqueue.queue(7,function(level,beat) --the number is in what order your extension will be loaded. lower = sooner
		
		--all of the functions you are adding to the level table go up here
	
		local function genericConditional(name, type)
			local cond = {}

			cond.type = type
			cond.name = name

			cond.id = #level.data.conditionals + #level.conditionals + 1
			cond.level = level

			cond.saver = {
				type = type,
				name = name,
				id = cond.id,
				tag = tostring(cond.id)
			}

			function cond:getid()
				return self.id .. 'd0'
			end

			function cond:save()
				table.insert(level.data.conditionals, cond.saver)
			end

			table.insert(level.conditionals, cond)
			return cond

		end

		function level:customConditional(name, expression)
			local cond = genericConditional(name, 'Custom')

			cond.expression = expression
			cond.saver.expression = expression

			return cond
		end

		function level:lastHitConditional(name, row, result)
			local cond = genericConditional(name, 'LastHit')

			cond.row = row; cond.result = result
			cond.saver.row = row; cond.saver.result = result

			return cond
		end

		function level:timesExecutedConditional(name, times)
			local cond = genericConditional(name, 'TimesExecuted')

			cond.times = times
			cond.saver.times = times

			return cond
		end

		function level:languageConditional(name, language)
			local cond = genericConditional(name, 'Language')

			cond.language = language
			cond.saver.language = language

			return cond
		end

		function level:playerModeConditional(name, isTwoPlayer)
			local cond = genericConditional(name, 'PlayerMode')

			cond.isTwoPlayer = not not isTwoPlayer
			cond.saver.isTwoPlayer = not not isTwoPlayer

			return cond
		end

		function level:getConditional(idx)
			if idx < #level.data.conditionals then
				return level.data.conditionals[idx + 1]
			else
				return level.conditionals[idx - #level.data.conditionals + 1]
			end
		end
	
		--if you need to initialize anything, do it here.

		
		
		-- fake event handlers
		
		--add event type condensers
		
	end)
end

return extension