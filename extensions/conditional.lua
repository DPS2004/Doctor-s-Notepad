local extension = function(_level)
	_level.initqueue.queue(7,function(level,beat) --the number is in what order your extension will be loaded. lower = sooner

		create_enum('rowhitjudgement', {'VeryEarly', 'SlightlyEarly', 'Perfect', 'SlightlyLate', 'VeryLate', 'AnyEarlyOrLate', 'Missed'})
	
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
			checkvar_type(name, 'name', 'string')
			checkvar_type(expression, 'expression', 'string')

			local cond = genericconditional(name, 'Custom')

			cond.expression = expression
			cond.saver.expression = expression

			return cond
		end

		function level:lasthitconditional(name, row, result)
			checkvar_type(name, 'name', 'string')
			checkvar_type(row, 'row', 'number')
			checkvar_enum(result, 'result', enums.rowhitjudgement)

			local cond = genericconditional(name, 'LastHit')

			if type(row) == 'table' then -- row object, get its id
				for i, v in ipairs(level.data.rows) do
					if level:getrow(v.row) == row then
						row = v.row
						break
					end
				end
			end
			if type(row) ~= 'number' then return end

			cond.row = row; cond.result = result
			cond.saver.row = row; cond.saver.result = result

			return cond
		end

		function level:timesexecutedconditional(name, times)
			checkvar_type(name, 'name', 'string')
			checkvar_type(times, 'times', 'number')

			local cond = genericconditional(name, 'TimesExecuted')

			cond.maxTimes = times
			cond.saver.maxTimes = times

			return cond
		end

		-- language can be
		-- English, Spanish, Portuguese, ChineseSimplified, ChineseTraditional, Korean, Polish, Japanese, German
		function level:languageconditional(name, language)
			checkvar_type(name, 'name', 'string')
			checkvar_type(language, 'language', 'number')

			local cond = genericconditional(name, 'Language')

			cond.language = language
			cond.saver.language = language

			return cond
		end

		function level:playermodeconditional(name, isTwoPlayer)
			checkvar_type(name, 'name', 'string')
			checkvar_type(isTwoPlayer, 'isTwoPlayer', 'boolean')

			local cond = genericconditional(name, 'PlayerMode')

			cond.isTwoPlayer = not not isTwoPlayer
			cond.saver.isTwoPlayer = not not isTwoPlayer

			return cond
		end

		function level:getconditional(idx)
			checkvar_type(idx, 'idx', 'number')

			if idx < #level.data.conditionals then
				return level.data.conditionals[idx + 1]
			else
				return level.conditionals[idx - #level.data.conditionals + 1]
			end
		end

		function level:getconditionalids(conditionals, duration)
			checkvar_type(conditionals, 'conditionals', 'table')
			checkvar_type(duration, 'duration', 'number')

			if #conditionals < 1 then return nil end

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

		function level:copyconditionals(conditionals)
			checkvar_type(conditionals, 'conditionals', 'table')

			local copies = {}

			for i = 1, #conditionals do
				local newCond = {}
				for k,v in pairs(conditionals[i]) do
					newCond[k] = v
				end
				table.insert(copies, newCond)
			end

			return copies
		end

		function level:conditional(conditionals, duration, func)
			checkvar_type(conditionals, 'conditionals', 'table')
			checkvar_type(duration, 'duration', 'number')
			checkvar_type(func, 'func', 'function', true)

			if not conditionals[1] then -- if this is not a list, and just a conditional
				conditionals = {conditionals} -- make it a list to not have issues later
			end
			if type(duration) == 'function' then -- if this is a function, set func to it (backwards compatibility)
				func = duration
				duration = 0
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

		-- aliases
		level.newconditional = level.customconditional -- backwards compatibility
		level.custom = level.customconditional
		level.lasthit = level.lasthitconditional
		level.timesexecuted = level.timesexecutedconditional
		level.language = level.languageconditional
		level.playermode = level.playermodeconditional
	
		--if you need to initialize anything, do it here.

		
		
		-- fake event handlers
		
		--add event type condensers
		
	end)
end

return extension