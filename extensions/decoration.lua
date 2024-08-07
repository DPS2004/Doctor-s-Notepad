local extension = function(_level)
	_level.initqueue.queue(3,function(level,beat) --the number is in what order your extension will be loaded. lower = sooner

		create_enum('decoborder', {'None', 'Outline', 'Glow'})
		create_enum('decotiletype', {'Scroll', 'Pulse'})
		
		--all of the functions you are adding to the level table go up here
	
		--create new decoration
		function level:newdecoration(filename, depth, roomidx, customname)

			filename = filename or ''
			depth = depth or 0
			roomidx = level:parseroom(roomidx)
			customname = customname or ('deco_' .. self.decoid)

			local deco = {}
			deco.objecttype = 'decoration'
			
			deco.level = self
			deco.id = customname
			deco.idx = self.decoid -- keep actual index in the table in this variable
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
				opacity = {{beat = 0, state = 100}},
				tilex = {{beat = 0, state = 1}},
				tiley = {{beat = 0, state = 1}},
				tilepx = {{beat = 0, state = 0}},
				tilepy = {{beat = 0, state = 0}},
				tilesx = {{beat = 0, state = 0}},
				tilesy = {{beat = 0, state = 0}}
			}

			self.decoid = self.decoid + 1


			function deco:save()

				table.insert(
					self.level.data.decorations,
					{
						id = self.id,
						row = self.idx,
						rooms = self.level:roomtable(self.room.index),
						filename = self.filename,
						depth = self.depth,
						visible = self.visibleatstart
					}
				)

			end


			function deco:setvisibleatstart(visible)
				checkvar_type(visible, 'visible', 'boolean')

				setvalue(self, 'visible', 0, visible)
				self.visibleatstart = visible

			end

			function deco:setroom(beat, room)
				checkvar_type(beat, 'beat', 'number')
				checkvar_type(room, 'room', 'number')

				setvalue(self, 'room', beat, room)
				self.level:addfakeevent(beat, 'updatedecox', {idx = self.idx, target = self.id, duration = 0, ease = 'Linear'})

			end

			function deco:movex(beat, v, duration, ease)
				checkvar_type(beat, 'beat', 'number')
				checkvar_typewithrdcode(v, 'v', 'number', 'number')
				checkvar_type(duration, 'duration', 'number', true)
				checkvar_enum(ease, 'ease', enums.ease, true)

				duration = duration or 0
				ease = ease or 'Linear'
				setvalue(self, 'x', beat, v)
				self.level:addfakeevent(beat, 'updatedecox', {idx = self.idx, target = self.id, duration = duration, ease = ease})

			end

			function deco:movey(beat, v, duration, ease)
				checkvar_type(beat, 'beat', 'number')
				checkvar_typewithrdcode(v, 'v', 'number', 'number')
				checkvar_type(duration, 'duration', 'number', true)
				checkvar_enum(ease, 'ease', enums.ease, true)

				duration = duration or 0
				ease = ease or 'Linear'
				setvalue(self, 'y', beat, v)
				self.level:addfakeevent(beat, 'updatedecoy', {idx = self.idx, target = self.id, duration = duration, ease = ease})

			end

			function deco:movesx(beat, v, duration, ease)
				checkvar_type(beat, 'beat', 'number')
				checkvar_typewithrdcode(v, 'v', 'number', 'number')
				checkvar_type(duration, 'duration', 'number', true)
				checkvar_enum(ease, 'ease', enums.ease, true)

				duration = duration or 0
				ease = ease or 'Linear'
				setvalue(self, 'sx', beat, v)
				self.level:addfakeevent(beat, 'updatedecosx', {idx = self.idx, target = self.id, duration = duration, ease = ease})

			end

			function deco:movesy(beat, v, duration, ease)
				checkvar_type(beat, 'beat', 'number')
				checkvar_typewithrdcode(v, 'v', 'number', 'number')
				checkvar_type(duration, 'duration', 'number', true)
				checkvar_enum(ease, 'ease', enums.ease, true)

				duration = duration or 0
				ease = ease or 'Linear'
				setvalue(self, 'sy', beat, v)
				self.level:addfakeevent(beat, 'updatedecosy', {idx = self.idx, target = self.id, duration = duration, ease = ease})

			end

			function deco:movepx(beat, v, duration, ease)
				checkvar_type(beat, 'beat', 'number')
				checkvar_type(v, 'v', 'number')
				checkvar_type(duration, 'duration', 'number', true)
				checkvar_enum(ease, 'ease', enums.ease, true)

				duration = duration or 0
				ease = ease or 'Linear'
				setvalue(self, 'px', beat, v)
				self.level:addfakeevent(beat, 'updatedecopx', {idx = self.idx, target = self.id, duration = duration, ease = ease})

			end

			function deco:movepy(beat, v, duration, ease)
				checkvar_type(beat, 'beat', 'number')
				checkvar_type(v, 'v', 'number')
				checkvar_type(duration, 'duration', 'number', true)
				checkvar_enum(ease, 'ease', enums.ease, true)

				duration = duration or 0
				ease = ease or 'Linear'
				setvalue(self, 'py', beat, v)
				self.level:addfakeevent(beat, 'updatedecopy', {idx = self.idx, target = self.id, duration = duration, ease = ease})

			end

			function deco:rotate(beat, v, duration, ease)
				checkvar_type(beat, 'beat', 'number')
				checkvar_typewithrdcode(v, 'v', 'number', 'number')
				checkvar_type(duration, 'duration', 'number', true)
				checkvar_enum(ease, 'ease', enums.ease, true)

				duration = duration or 0
				ease = ease or 'Linear'
				setvalue(self, 'rot', beat, v)
				self.level:addfakeevent(beat, 'updatedecorot', {idx = self.idx, target = self.id, duration = duration, ease = ease})

			end

			function deco:tilex(beat, v, duration, ease)
				checkvar_type(beat, 'beat', 'number')
				checkvar_type(v, 'v', 'number')
				checkvar_type(duration, 'duration', 'number', true)
				checkvar_enum(ease, 'ease', enums.ease, true)

				duration = duration or 0
				ease = ease or 'Linear'
				setvalue(self, 'tilex', beat, v)
				self.level:addfakeevent(beat, 'updatedecotilex', {idx = self.idx, target = self.id, duration = duration, ease = ease})
			end

			function deco:tiley(beat, v, duration, ease)
				checkvar_type(beat, 'beat', 'number')
				checkvar_type(v, 'v', 'number')
				checkvar_type(duration, 'duration', 'number', true)
				checkvar_enum(ease, 'ease', enums.ease, true)

				duration = duration or 0
				ease = ease or 'Linear'
				setvalue(self, 'tiley', beat, v)
				self.level:addfakeevent(beat, 'updatedecotiley', {idx = self.idx, target = self.id, duration = duration, ease = ease})
			end

			function deco:tilepx(beat, v, duration, ease)
				checkvar_type(beat, 'beat', 'number')
				checkvar_type(v, 'v', 'number')
				checkvar_type(duration, 'duration', 'number', true)
				checkvar_enum(ease, 'ease', enums.ease, true)

				duration = duration or 0
				ease = ease or 'Linear'
				setvalue(self, 'tilepx', beat, v)
				self.level:addfakeevent(beat, 'updatedecotilepx', {idx = self.idx, target = self.id, duration = duration, ease = ease})
			end

			function deco:tilepy(beat, v, duration, ease)
				checkvar_type(beat, 'beat', 'number')
				checkvar_type(v, 'v', 'number')
				checkvar_type(duration, 'duration', 'number', true)
				checkvar_enum(ease, 'ease', enums.ease, true)

				duration = duration or 0
				ease = ease or 'Linear'
				setvalue(self, 'tilepy', beat, v)
				self.level:addfakeevent(beat, 'updatedecotilepy', {idx = self.idx, target = self.id, duration = duration, ease = ease})
			end

			function deco:tilesx(beat, v, tiletype, type, duration, ease)
				checkvar_type(beat, 'beat', 'number')
				checkvar_type(v, 'v', 'number')
				checkvar_enum(tiletype, 'tiletype', enums.decotiletype)
				checkvar_type(duration, 'duration', 'number', true)
				checkvar_enum(ease, 'ease', enums.ease, true)

				duration = duration or 0
				ease = ease or 'Linear'
				setvalue(self, 'tilesx', beat, v)
				self.level:addfakeevent(beat, 'updatedecotilesx', {idx = self.idx, target = self.id, tiletype = tiletype, duration = duration, ease = ease})
			end

			function deco:tilesy(beat, v, tiletype, duration, ease)
				checkvar_type(beat, 'beat', 'number')
				checkvar_type(v, 'v', 'number')
				checkvar_enum(tiletype, 'tiletype', enums.decotiletype)
				checkvar_type(duration, 'duration', 'number', true)
				checkvar_enum(ease, 'ease', enums.ease, true)

				duration = duration or 0
				ease = ease or 'Linear'
				setvalue(self, 'tilesy', beat, v)
				self.level:addfakeevent(beat, 'updatedecotilesy', {idx = self.idx, target = self.id, tiletype = tiletype, duration = duration, ease = ease})
			end

			function deco:move(beat, t, duration, ease)
				checkvar_type(beat, 'beat', 'number')
				checkvar_type(t, 't', 'table')
				checkvar_type(duration, 'duration', 'number', true)
				checkvar_enum(ease, 'ease', enums.ease, true)

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
				checkvar_type(beat, 'beat', 'number')

				setvalue(self, 'visible', beat, true)

				self.level:addfakeevent(beat, "updatedecovisible", {idx = self.idx, target = self.id})

			end

			function deco:hide(beat)
				checkvar_type(beat, 'beat', 'number')

				setvalue(self, 'visible', beat, false)

				self.level:addfakeevent(beat, "updatedecovisible", {idx = self.idx, target = self.id})

			end

			function deco:playexpression(beat, expression)
				checkvar_type(beat, 'beat', 'number')
				checkvar_type(expression, 'expression', 'string')

				beat = beat or 0
				expression = expression or 'neutral'

				self.level:addevent(beat, "PlayAnimation", {idx = self.idx, target = self.id, expression = expression})

			end

			function deco:setborder(beat, bordertype, color, opacity, duration, ease)
				checkvar_type(beat, 'beat', 'number')
				checkvar_enum(bordertype, 'bordertype', enums.decoborder)
				checkvar_color(color, 'color')
				checkvar_type(opacity, 'opacity', 'number')
				checkvar_type(duration, 'duration', 'number', true)
				checkvar_enum(ease, 'ease', enums.ease, true)

				duration = duration or 0
				ease = ease or "Linear"

				setvalue(self, "border", beat, bordertype)
				setvalue(self, "bordercolor", beat, color)
				setvalue(self, "borderopacity", beat, opacity)

				self.level:addfakeevent(beat, "updatedecotint", {idx = self.idx, target = self.id, duration = duration, ease = ease})

			end

			function deco:settint(beat, showtint, color, opacity, duration, ease)
				checkvar_type(beat, 'beat', 'number')
				checkvar_type(showtint, 'showtint', 'boolean')
				checkvar_color(color, 'color')
				checkvar_type(opacity, 'opacity', 'number')
				checkvar_type(duration, 'duration', 'number', true)
				checkvar_enum(ease, 'ease', enums.ease, true)

				duration = duration or 0
				ease = ease or "Linear"

				setvalue(self, "tint", beat, showtint)
				setvalue(self, "tintcolor", beat, color)
				setvalue(self, "tintopacity", beat, opacity)

				self.level:addfakeevent(beat, "updatedecotint", {idx = self.idx, target = self.id, duration = duration, ease = ease})

			end

			function deco:setopacity(beat, opacity, duration, ease)
				checkvar_type(beat, 'beat', 'number')
				checkvar_type(opacity, 'opacity', 'number')
				checkvar_type(duration, 'duration', 'number', true)
				checkvar_enum(ease, 'ease', enums.ease, true)

				duration = duration or 0
				ease = ease or 'Linear'
				setvalue(self, "opacity", beat, opacity)
				self.level:addfakeevent(beat, "updatedecotint", {idx = self.idx, target = self.id, duration = duration, ease = ease})

			end


			self.decorations[deco.idx] = deco

			return deco
			
		end

		function level:getdecoration(idx)

			return level.decorations[idx]

		end

	
		--if you need to initialize anything, do it here.

		level.decoid = 0

		-- make already-existing decos into deco objects
		level.decorations = {}

		level.data.decorations = level.data.decorations or {}
		for i, v in ipairs(level.data.decorations) do

            local newdeco = level:newdecoration(v.filename, v.depth, v.rooms[1], v.id)
            newdeco:setvisibleatstart(v.visible)

        end

        -- make sure they arent duplicated when saving by removing them from the original file completely
        level.data.decorations = {}
		
		
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
				}, v._tag,v._cond
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
				}, v._tag,v._cond
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
				}, v._tag,v._cond
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
				}, v._tag,v._cond
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
				}, v._tag,v._cond
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
				}, v._tag,v._cond
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
				}, v._tag,v._cond
			)

		end)

		level:fakehandler('updatedecotilepx', function(self,v)

			self:addevent(
				v.beat,
				'Tile',
				{
					target = v.target,
					position = {
						getvalue(self.decorations[v.idx], 'tilepx', v.beat),
						null
					},
					duration = v.duration,
					ease = v.ease
				}, v._tag,v._cond
			)

		end)

		level:fakehandler('updatedecotilepy', function(self,v)

			self:addevent(
				v.beat,
				'Tile',
				{
					target = v.target,
					position = {
						null,
						getvalue(self.decorations[v.idx], 'tilepy', v.beat)
					},
					duration = v.duration,
					ease = v.ease
				}, v._tag,v._cond
			)

		end)

		level:fakehandler('updatedecotilex', function(self,v)

			self:addevent(
				v.beat,
				'Tile',
				{
					target = v.target,
					tiling = {
						getvalue(self.decorations[v.idx], 'tilex', v.beat),
						null
					},
					duration = v.duration,
					ease = v.ease
				}, v._tag,v._cond
			)

		end)

		level:fakehandler('updatedecotiley', function(self,v)

			self:addevent(
				v.beat,
				'Tile',
				{
					target = v.target,
					tiling = {
						null,
						getvalue(self.decorations[v.idx], 'tiley', v.beat)
					},
					duration = v.duration,
					ease = v.ease
				}, v._tag,v._cond
			)

		end)

		level:fakehandler('updatedecotilesx', function(self,v)

			self:addevent(
				v.beat,
				'Tile',
				{
					target = v.target,
					speed = {
						getvalue(self.decorations[v.idx], 'tilesx', v.beat),
						null
					},
					tilingType = v.tiletype,
					duration = v.duration,
					ease = v.ease
				}, v._tag,v._cond
			)

		end)

		level:fakehandler('updatedecotilesy', function(self,v)

			self:addevent(
				v.beat,
				'Tile',
				{
					target = v.target,
					speed = {
						null,
						getvalue(self.decorations[v.idx], 'tilesy', v.beat)
					},
					tilingType = v.tiletype,
					duration = v.duration,
					ease = v.ease
				}, v._tag,v._cond
			)

		end)

		level:fakehandler('updatedecovisible', function(self,v)

			self:addevent(
				v.beat,
				'SetVisible',
				{
					target = v.target,
					visible = getvalue(self.decorations[v.idx], 'visible', v.beat)
				}, v._tag,v._cond
			)

		end)

		level:fakehandler('updatedecotint',function(self,v)
			self:addevent(
				v.beat,
				"Tint",
				{
					target = v.target,
					border = getvalue(self.decorations[v.idx], "border", v.beat),
					borderColor = getvalue(self.decorations[v.idx], "bordercolor", v.beat) .. level:alpha(getvalue(self.decorations[v.idx], "borderopacity", v.beat)),
					tint = getvalue(self.decorations[v.idx], "tint", v.beat),
					tintColor = getvalue(self.decorations[v.idx], "tintcolor", v.beat) .. level:alpha(getvalue(self.decorations[v.idx], "tintopacity", v.beat)),
					opacity = getvalue(self.decorations[v.idx], 'opacity', v.beat),
					duration = v.duration,
					ease = v.ease
				}, v._tag,v._cond
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