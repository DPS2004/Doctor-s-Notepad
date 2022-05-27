local extension = function(_level)
	_level.initqueue.queue(3,function(level,beat) --the number is in what order your extension will be loaded. lower = sooner
		
		--all of the functions you are adding to the level table go up here
	
		--create new decoration
		function level:newdecoration(filename, depth, roomidx)

			filename = filename or ''
			depth = depth or 0
			roomidx = math.min(math.max((roomidx or 0), 0), 3) -- clamp between 0 and 3

			local deco = {}

			deco.level = self
			deco.id = 'deco_' .. self.decoid
			deco.idx = self.decoid + 1 -- so idx accurately reflects the index in the table
			deco.room = level:getroom(roomidx)
			deco.filename = filename
			deco.depth = depth
			deco.visibleatstart = true
			deco.values = {
				room = {{beat = 0, state = roomidx}},
				x = {{beat = 0, state = 50}},
				y = {{beat = 0, state = 50}},
				sx = {{beat = 0, state = 100}},
				sy = {{beat = 0, state = 100}},
				px = {{beat = 0, state = 50}},
				py = {{beat = 0, state = 50}},
				rot = {{beat = 0, state = 0}},
				border = {{beat = 0, state = "None"}},
				bordercolor = {{beat = 0, state = "000000"}},
				borderopacity = {{beat = 0, state = 100}},
				tint = {{beat = 0, state = false}},
				tintcolor = {{beat = 0, state = "FFFFFF"}},
				tintopacity = {{beat = 0, state = 100}},
				visible = {{beat = 0, state = true}},
				opacity = {{beat = 0, state = 100}}
			}

			self.decoid = self.decoid + 1


			function deco:save()

				table.insert(
					self.level.data.decorations,
					{
						id = self.id,
						row = self.idx - 1,
						rooms = self.level:roomtable(self.room.index),
						filename = self.filename,
						depth = self.depth,
						visible = self.visibleatstart
					}
				)

			end


			function deco:setvisibleatstart(visible)

				visible = not not visible -- nil, false -> false; other cases -> true

				setvalue(self, 'visible', 0, visible)
				self.visibleatstart = visible

			end

			function deco:setroom(beat, room)

				setvalue(self, 'room', beat, room)
				self.level:addfakeevent(beat, 'updatedecox', {idx = self.idx, target = self.id, duration = 0, ease = 'Linear'})

			end

			function deco:movex(beat, v, duration, ease)

				duration = duration or 0
				ease = ease or 'Linear'
				setvalue(self, 'x', beat, v)
				self.level:addfakeevent(beat, 'updatedecox', {idx = self.idx, target = self.id, duration = duration, ease = ease})

			end

			function deco:movey(beat, v, duration, ease)

				duration = duration or 0
				ease = ease or 'Linear'
				setvalue(self, 'y', beat, v)
				self.level:addfakeevent(beat, 'updatedecoy', {idx = self.idx, target = self.id, duration = duration, ease = ease})

			end

			function deco:movesx(beat, v, duration, ease)

				duration = duration or 0
				ease = ease or 'Linear'
				setvalue(self, 'sx', beat, v)
				self.level:addfakeevent(beat, 'updatedecosx', {idx = self.idx, target = self.id, duration = duration, ease = ease})

			end

			function deco:movesy(beat, v, duration, ease)

				duration = duration or 0
				ease = ease or 'Linear'
				setvalue(self, 'sy', beat, v)
				self.level:addfakeevent(beat, 'updatedecosy', {idx = self.idx, target = self.id, duration = duration, ease = ease})

			end

			function deco:movepx(beat, v, duration, ease)

				duration = duration or 0
				ease = ease or 'Linear'
				setvalue(self, 'px', beat, v)
				self.level:addfakeevent(beat, 'updatedecopx', {idx = self.idx, target = self.id, duration = duration, ease = ease})

			end

			function deco:movepy(beat, v, duration, ease)

				duration = duration or 0
				ease = ease or 'Linear'
				setvalue(self, 'py', beat, v)
				self.level:addfakeevent(beat, 'updatedecopy', {idx = self.idx, target = self.id, duration = duration, ease = ease})

			end

			function deco:rotate(beat, v, duration, ease)

				duration = duration or 0
				ease = ease or 'Linear'
				setvalue(self, 'rot', beat, v)
				self.level:addfakeevent(beat, 'updatedecorot', {idx = self.idx, target = self.id, duration = duration, ease = ease})

			end

			function deco:move(beat, t, duration, ease)

				duration = duration or 0
				ease = ease or 'Linear'

				for k,v in pairs(t) do
					if k == 'rot' or k == 'rotate' then -- special case for rotate and rot
						self:rotate(beat, v, duration, ease)
					else
						local method = 'move'..k -- if not rotate/rot then make a function name
						if self[method] then -- see if the decoration has that function (cant call something like deco:movez because it doesnt exist!)
							self[method](self, beat, v, duration, ease) -- call the function, self is given as the first argument because i dont think theres a way to do : with this method
						end
					end
				end

			end

			function deco:show(beat)

				setvalue(self, 'visible', beat, true)

				self.level:addfakeevent(beat, "updatedecovisible", {idx = self.idx, target = self.id})

			end

			function deco:hide(beat)

				setvalue(self, 'visible', beat, false)

				self.level:addfakeevent(beat, "updatedecovisible", {idx = self.idx, target = self.id})

			end

			function deco:playexpression(beat, expression)

				beat = beat or 0
				expression = expression or 'neutral'

				self.level:addevent(beat, "PlayAnimation", {idx = self.idx, target = self.id, expression = expression})

			end

			function deco:setborder(beat, bordertype, color, opacity, duration, ease)

				color = color or "000000"
				opacity = opacity or 100
				duration = duration or 0
				ease = ease or "Linear"

				setvalue(self, "border", beat, bordertype)
				setvalue(self, "bordercolor", beat, color)
				setvalue(self, "borderopacity", beat, opacity)

				self.level:addfakeevent(beat, "updatedecotint", {idx = self.idx, target = self.id, duration = duration, ease = ease})

			end

			function deco:settint(beat, showtint, color, opacity, duration, ease)

				color = color or "FFFFFF"
				opacity = opacity or 100
				duration = duration or 0
				ease = ease or "Linear"

				setvalue(self, "tint", beat, showtint)
				setvalue(self, "tintcolor", beat, color)
				setvalue(self, "tintopacity", beat, opacity)

				self.level:addfakeevent(beat, "updatedecotint", {idx = self.idx, target = self.id, duration = duration, ease = ease})

			end

			function deco:setopacity(beat, opacity, duration, ease)

				setvalue(self, "opacity", beat, opacity)
				self.level:addfakeevent(beat, "updatedecotint", {idx = self.idx, target = self.id, duration = duration, ease = ease})

			end


			table.insert(self.decorations, deco)

			return deco
			
		end

	
		--if you need to initialize anything, do it here.

		
		
		
		-- fake event handlers

		level:fakehandler('updatedecox', function(self,v)

			self:addevent(
				v.beat,
				'Move',
				{
					target = v.target,
					position = {
						getvalue(self.decorations[v.idx], 'x', v.beat) + (getvalue(self.decorations[v.idx], 'room', v.beat) - self.decorations[v.idx].room.index) * 852.2727,
						null
					},
					duration = v.duration,
					ease = v.ease
				}
			)

		end)

		level:fakehandler('updatedecoy', function(self,v)

			self:addevent(
				v.beat,
				'Move',
				{
					target = v.target,
					position = {
						null,
						getvalue(self.decorations[v.idx], 'y', v.beat)
					},
					duration = v.duration,
					ease = v.ease
				}
			)

		end)

		level:fakehandler('updatedecosx', function(self,v)

			self:addevent(
				v.beat,
				'Move',
				{
					target = v.target,
					scale = {
						getvalue(self.decorations[v.idx], 'sx', v.beat),
						null
					},
					duration = v.duration,
					ease = v.ease
				}
			)

		end)

		level:fakehandler('updatedecosy', function(self,v)

			self:addevent(
				v.beat,
				'Move',
				{
					target = v.target,
					scale = {
						null,
						getvalue(self.decorations[v.idx], 'sy', v.beat)
					},
					duration = v.duration,
					ease = v.ease
				}
			)

		end)

		level:fakehandler('updatedecopx', function(self,v)

			self:addevent(
				v.beat,
				'Move',
				{
					target = v.target,
					pivot = {
						getvalue(self.decorations[v.idx], 'px', v.beat),
						null
					},
					duration = v.duration,
					ease = v.ease
				}
			)

		end)

		level:fakehandler('updatedecopy', function(self,v)

			self:addevent(
				v.beat,
				'Move',
				{
					target = v.target,
					pivot = {
						null,
						getvalue(self.decorations[v.idx], 'py', v.beat)
					},
					duration = v.duration,
					ease = v.ease
				}
			)

		end)

		level:fakehandler('updatedecorot', function(self,v)

			self:addevent(
				v.beat,
				'Move',
				{
					target = v.target,
					angle = getvalue(self.decorations[v.idx], 'rot', v.beat),
					duration = v.duration,
					ease = v.ease
				}
			)

		end)

		level:fakehandler('updatedecovisible', function(self,v)

			self:addevent(
				v.beat,
				'SetVisible',
				{
					target = v.target,
					visible = getvalue(self.decorations[v.idx], 'visible', v.beat)
				}
			)

		end)

		level:fakehandler('updatedecotint',function(self,v)
			self:addevent(
				v.beat,
				"Tint",
				{
					target = v.target,
					border = getvalue(self.decorations[v.idx], "border", v.beat),
					borderColor = getvalue(self.decorations[v.idx], "bordercolor", v.beat),
					borderOpacity = getvalue(self.decorations[v.idx], "borderopacity", v.beat),
					tint = getvalue(self.decorations[v.idx], "tint", v.beat),
					tintColor = getvalue(self.decorations[v.idx], "tintcolor", v.beat),
					tintOpacity = getvalue(self.decorations[v.idx], "tintopacity", v.beat),
					opacity = getvalue(self.decorations[v.idx], 'opacity', v.beat),
					duration = v.duration,
					ease = v.ease
				}
			)
		end)
		
		--add event type condensers

		level:condenser('Move',function(self,elist)
			local condensed = {}
			local groups = self:getcondensable(elist,{
				'target',
				'duration',
				'ease'
			})
			for i,v in ipairs(groups) do
				table.insert(condensed,self:mergegroup(v))
			end
			return condensed
		end)
		
	end)
end

return extension