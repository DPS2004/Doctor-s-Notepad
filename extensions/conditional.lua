local extension = function(_level)
	_level.initqueue.queue(7,function(level,beat) --the number is in what order your extension will be loaded. lower = sooner
		
		--all of the functions you are adding to the level table go up here
	
		local function genericconditional(name, type)
			local cond = {}

			cond.type = type
			cond.name = name

			cond.id = #level.data.conditionals + #level.conditionals + 1
			cond.level = level
			cond._red = false

			cond.saver = {
				type = type,
				name = name,
				id = cond.id,
				tag = tostring(cond.id)
			}

			function cond:red(bool)
				cond._red = not not bool
			end

			function cond:save()
				table.insert(level.data.conditionals, cond.saver)
			end

			table.insert(level.conditionals, cond)
			return cond

		end

		function level:customconditional(name, expression)
			local cond = genericconditional(name, 'Custom')

			cond.expression = expression
			cond.saver.expression = expression

			return cond
		end

		-- result can be
		-- VeryEarly, SlightlyEarly, Perfect, SlightlyLate, VeryLate, AnyEarlyOrLate, Missed
		function level:lasthitconditional(name, row, result)
			local cond = genericconditional(name, 'LastHit')

			cond.row = row; cond.result = result
			cond.saver.row = row; cond.saver.result = result

			return cond
		end

		function level:timesexecutedconditional(name, times)
			local cond = genericconditional(name, 'TimesExecuted')

			cond.times = times
			cond.saver.times = times

			return cond
		end

		-- language can be
		-- English, Spanish, Portuguese, ChineseSimplified, ChineseTraditional, Korean, Polish, Japanese, German
		function level:languageconditional(name, language)
			local cond = genericconditional(name, 'Language')

			cond.language = language
			cond.saver.language = language

			return cond
		end

		function level:playermodeconditional(name, isTwoPlayer)
			local cond = genericconditional(name, 'PlayerMode')

			cond.isTwoPlayer = not not isTwoPlayer
			cond.saver.isTwoPlayer = not not isTwoPlayer

			return cond
		end

		function level:getconditional(idx)
			if idx < #level.data.conditionals then
				return level.data.conditionals[idx + 1]
			else
				return level.conditionals[idx - #level.data.conditionals + 1]
			end
		end

		function level:getconditionalids(conditionals, duration)
			if not conditionals then return nil end

			local ids = {}

			for i = 1, #conditionals do
				local cond = conditionals[i]

				if cond._red then
					table.insert(ids, '~' .. tostring(cond.id))
				else
					table.insert(ids, tostring(cond.id))
				end
			end

			return table.concat(ids, '&') .. 'd' .. tostring(duration)

		end

		function level:conditional(conditionals, duration, func)
			if not conditionals[1] then 
				conditionals = {conditionals}
			end

			self.autocond = conditionals
			self.autocondduration = duration or 0

			if func then
				func()
				self:endconditional()
			end

		end
		
		function level:endconditional()
			self.autocond = nil
		end
	
		--if you need to initialize anything, do it here.

		
		
		-- fake event handlers
		
		--add event type condensers
		
	end)
end

return extension