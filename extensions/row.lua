local extension = function(_level)
	_level.initqueue.queue(1,function(level,beat)
		--defines a row object
		function level:getrow(index)
			if level.rows[index] then
				return level.rows[index]
			end

			local row = {}
			row.level = self
			row.data =
				tget(
				self.data.rows,
				function(v)
					return v.row == index
				end
			)
			-- set up persistent value timelines that can be accessed by other commands
			row.values = {
				room = {{beat = 0, state = 0}},

				-- whole row
				x = {{beat = 0, state = 50}},
				y = {{beat = 0, state = 50}},
				sx = {{beat = 0, state = 1}},
				sy = {{beat = 0, state = 1}},
				pivot = {{beat = 0, state = 0.5}},
				rot = {{beat = 0, state = 0}},
				
				-- character
				cx = {{beat = 0, state = 0}},
				cy = {{beat = 0, state = 0}},
				csx = {{beat = 0, state = 100}},
				csy = {{beat = 0, state = 100}},
				crot = {{beat = 0, state = 0}},

				-- heart
				hx = {{beat = 0, state = 0}},
				hy = {{beat = 0, state = 0}},
				hsx = {{beat = 0, state = 100}},
				hsy = {{beat = 0, state = 100}},
				hrot = {{beat = 0, state = 0}},
				
				--tint row
				border = {{beat = 0, state = "None"}},
				bordercolor = {{beat = 0, state = "000000"}},
				borderopacity = {{beat = 0, state = 100}},
				tint = {{beat = 0, state = false}},
				tintcolor = {{beat = 0, state = "FFFFFF"}},
				tintopacity = {{beat = 0, state = 100}},
				hidden = {{beat = 0, state = false}},
				electric = {{beat = 0, state = false}},
				opacity = {{beat = 0, state = 100}}
			}

			function row:setroom(beat, room)
				setvalue(self, "room", beat, room)
				self.level:addfakeevent(beat, "updaterowx", {row = index, duration = 0, ease = "Linear"})
			end

			function row:movex(beat, x, duration, ease)
				duration = duration or 0
				ease = ease or "Linear"
				setvalue(self, "x", beat, x)
				self.level:addfakeevent(beat, "updaterowx", {row = index, duration = duration, ease = ease})
			end

			function row:movey(beat, y, duration, ease)
				duration = duration or 0
				ease = ease or "Linear"
				setvalue(self, "y", beat, y)
				self.level:addfakeevent(beat, "updaterowy", {row = index, duration = duration, ease = ease})
			end
			
			function row:movesx(beat, x, duration, ease)
				duration = duration or 0
				ease = ease or "Linear"
				setvalue(self, "sx", beat, x)
				self.level:addfakeevent(beat, "updaterowsx", {row = index, duration = duration, ease = ease})
			end

			function row:movesy(beat, y, duration, ease)
				duration = duration or 0
				ease = ease or "Linear"
				setvalue(self, "sy", beat, y)
				self.level:addfakeevent(beat, "updaterowsy", {row = index, duration = duration, ease = ease})
			end
			function row:rotate(beat, rot, duration, ease)
				duration = duration or 0
				ease = ease or "Linear"
				setvalue(self, "rot", beat, rot)
				self.level:addfakeevent(beat, "updaterowrot", {row = index, duration = duration, ease = ease})
			end

			function row:movepivot(beat, pivot, duration, ease)
				duration = duration or 0
				ease = ease or "Linear"
				setvalue(self, "pivot", beat, pivot)
				self.level:addfakeevent(beat, "updaterowpivot", {row = index, duration = duration, ease = ease})
			end
			
			
			function row:movecx(beat, x, duration, ease)
				duration = duration or 0
				ease = ease or "Linear"
				setvalue(self, "cx", beat, x)
				self.level:addfakeevent(beat, "updaterowcx", {row = index, duration = duration, ease = ease})
			end

			function row:movecy(beat, y, duration, ease)
				duration = duration or 0
				ease = ease or "Linear"
				setvalue(self, "cy", beat, y)
				self.level:addfakeevent(beat, "updaterowcy", {row = index, duration = duration, ease = ease})
			end
			function row:crotate(beat, rot, duration, ease)
				duration = duration or 0
				ease = ease or "Linear"
				setvalue(self, "crot", beat, rot)
				self.level:addfakeevent(beat, "updaterowcrot", {row = index, duration = duration, ease = ease})
			end

			function row:movecsx(beat, x, duration, ease)
				duration = duration or 0
				ease = ease or "Linear"
				setvalue(self, "csx", beat, x)
				self.level:addfakeevent(beat, "updaterowcsx", {row = index, duration = duration, ease = ease})
			end

			function row:movecsy(beat, y, duration, ease)
				duration = duration or 0
				ease = ease or "Linear"
				setvalue(self, "csy", beat, y)
				self.level:addfakeevent(beat, "updaterowcsy", {row = index, duration = duration, ease = ease})
			end

			function row:movehx(beat, x, duration, ease)
				duration = duration or 0
				ease = ease or "Linear"
				setvalue(self, "hx", beat, x)
				self.level:addfakeevent(beat, "updaterowhx", {row = index, duration = duration, ease = ease})
			end

			function row:movehy(beat, y, duration, ease)
				duration = duration or 0
				ease = ease or "Linear"
				setvalue(self, "hy", beat, y)
				self.level:addfakeevent(beat, "updaterowhy", {row = index, duration = duration, ease = ease})
			end
			function row:hrotate(beat, rot, duration, ease)
				duration = duration or 0
				ease = ease or "Linear"
				setvalue(self, "hrot", beat, rot)
				self.level:addfakeevent(beat, "updaterowhrot", {row = index, duration = duration, ease = ease})
			end

			function row:movehsx(beat, x, duration, ease)
				duration = duration or 0
				ease = ease or "Linear"
				setvalue(self, "hsx", beat, x)
				self.level:addfakeevent(beat, "updaterowhsx", {row = index, duration = duration, ease = ease})
			end

			function row:movehsy(beat, y, duration, ease)
				duration = duration or 0
				ease = ease or "Linear"
				setvalue(self, "hsy", beat, y)
				self.level:addfakeevent(beat, "updaterowhsy", {row = index, duration = duration, ease = ease})
			end
			

			function row:move(beat, p, duration, ease)
				duration = duration or 0
				ease = ease or "Linear"
				for k, v in pairs(p) do

					if k ==  'rotate' or k ==  'rot' then
						self:rotate(beat, v, duration, ease)  -- special handling for rotate, rot
					elseif k == 'crotate' or k == 'crot' then
						self:crotate(beat, v, duration, ease) -- special handling for crotate, crot
					elseif k == 'hrotate' or k == 'hrot' then
						self:hrotate(beat, v, duration, ease) -- special handling for hrotate, hrot
					else
						-- kinda modular way of calling functions such as movex or movecsy without having a long-ass if-else statement
						-- should work just fine i think, though the old if-else statement is still there, just commented out, just in case
						local func = 'move'..k
						if self[func] then
							self[func](self, beat, v, duration, ease) -- dont think you can use : with this method though so gotta pass in self for the first variable
						end
					end

					--[[
					if k == "x" then
						self:movex(beat, v, duration, ease)
					elseif k == "y" then
						self:movey(beat, v, duration, ease)
					elseif k == "sx" then
						self:movesx(beat, v, duration, ease)
					elseif k == "sy" then
						self:movesy(beat, v, duration, ease)
					elseif k == "pivot" then
						self:movepivot(beat, v, duration, ease)
					elseif k == "rotate" or k == "rot" then
						self:rotate(beat, v, duration, ease)
					elseif k == "cx" then
						self:movecx(beat, v, duration, ease)
					elseif k == "cy" then
						self:movecy(beat, v, duration, ease)
					elseif k == "csx" then
						self:movecsx(beat, v, duration, ease)
					elseif k == "csy" then
						self:movecsy(beat, v, duration, ease)
					elseif k == "crotate" or k == "crot" then
						self:crotate(beat, v, duration, ease)
					end
					]]
				end
			end
			
			
			
			
			
			
			--expressions
			
			
			function row:playexpression(beat,expression)
				beat = beat or 0
				expression = expression or 'neutral'
				self.level:addevent(beat, "PlayExpression", {row = index, expression = expression, replace = false})
			end
			
			function row:swapexpression(beat,target,expression)
				beat = beat or 0
				target = target or 'neutral'
				expression = expression or 'neutral'
				self.level:addevent(beat, "PlayExpression", {row = index, target = target, expression = expression, replace = true})
			end

			-- set hideAtStart
			function row:setvisibleatstart(vis)
				if vis == nil then
					vis = false
				end
				vis = not vis

				self.data.hideAtStart = vis

				setvalue(self, "hidden", 0, vis)

				self:save()
			end

			function row:setborder(beat, bordertype, color, opacity, duration, ease)
				color = color or "000000"
				opacity = opacity or 100
				duration = duration or 0
				ease = ease or "linear"
				setvalue(self, "border", beat, bordertype)
				setvalue(self, "bordercolor", beat, color)
				setvalue(self, "borderopacity", beat, opacity)

				self.level:addfakeevent(beat, "updaterowtint", {duration = duration, ease = ease, row = index})
			end

			function row:settint(beat, showtint, color, opacity, duration, ease)
				color = color or "FFFFFF"
				opacity = opacity or 100
				duration = duration or 0
				ease = ease or "linear"
				setvalue(self, "tint", beat, showtint)
				setvalue(self, "tintcolor", beat, color)
				setvalue(self, "tintopacity", beat, opacity)

				self.level:addfakeevent(beat, "updaterowtint", {duration = duration, ease = ease, row = index})
			end

			function row:setopacity(beat, opacity, duration, ease)

				setvalue(self, "opacity", beat, opacity)
				self.level:addfakeevent(beat, "updaterowtint", {duration = duration, ease = ease, row = index})

			end
			
			function row:show(beat, smooth)
				beat = beat or 0
				smooth = smooth or 0
				local smoothn = smooth
				if type(smooth) == 'boolean' then
					if smooth then 
						smoothn = 1
					else
						smoothn = 0
					end
				end
				local transition = 'Instant'
				if smoothn == 1 then
					transition = 'Smooth'
				elseif smoothn == 2 then 
					transition = 'Full'
				end
				setvalue(self, "hidden", beat, false)

				self.level:addfakeevent(beat, "updaterowshow", {transition = transition, show = 'Visible', row = index})
			end
			
			function row:hide(beat, smooth)
				smooth = smooth or 0
				local smoothn = smooth
				if type(smooth) == 'boolean' then
					if smooth then 
						smoothn = 1
					else
						smoothn = 0
					end
				end
				local transition = 'Instant'
				if smoothn ~= 0 then
					transition = 'Smooth'
				end
				setvalue(self, "hidden", beat, true)

				self.level:addfakeevent(beat, "updaterowshow", {transition = transition, show = 'Hidden', row = index})
			end
			
			function row:showchar(beat, smooth)
				smooth = smooth or 0
				local smoothn = smooth
				if type(smooth) == 'boolean' then
					if smooth then 
						smoothn = 1
					else
						smoothn = 0
					end
				end
				local transition = 'Instant'
				if smoothn == 1 then
					transition = 'Smooth'
				elseif smoothn == 2 then 
					transition = 'Full'
				end
				setvalue(self, "hidden", beat, false)

				self.level:addfakeevent(beat, "updaterowshow", {transition = transition, show = 'OnlyCharacter', row = index})
			end
			
			function row:showrow(beat, smooth)
				smooth = smooth or 0
				local smoothn = smooth
				if type(smooth) == 'boolean' then
					if smooth then 
						smoothn = 1
					else
						smoothn = 0
					end
				end
				local transition = 'Instant'
				if smoothn == 1 then
					transition = 'Smooth'
				elseif smoothn == 2 then 
					transition = 'Full'
				end
				setvalue(self, "hidden", beat, false)

				self.level:addfakeevent(beat, "updaterowshow", {transition = transition, show = 'OnlyRow', row = index})
			end
			
			function row:togglevis(beat,smooth)
				if getvalue(self, "hidden", beat) then
					self:show(beat,smooth)
				else
					self:hide(beat,smooth)
				end
			end
			

			--save to level
			function row:save()
				tset(
					self.level.data.rows,
					function(v)
						return v.row == index
					end,
					self
				)
			end

			level.rows[index] = row

			return row
		end
		
		
		-- border every row
		function level:allborder(beat, bordertype, color, opacity, duration, ease)
			for k, v in pairs(self.rows) do
				v:setborder(beat, bordertype, color, opacity, duration, ease)
			end
		end

		-- tint every row
		function level:alltint(beat, showtint, color, opacity, duration, ease)
			for k, v in pairs(self.rows) do
				v:settint(beat, showtint, color, opacity, duration, ease)
			end
		end

		function level:allglow(beat, color, opacity, duration, ease)
			beat = beat or 0
			self:allborder(beat, "Glow", color, opacity, duration, ease)
		end

		function level:alloutline(beat, color, opacity, duration, ease)
			beat = beat or 0
			self:allborder(beat, "Outline", color, opacity, duration, ease)
		end
		
		function level:hideallatstart()
			for k,v in pairs(self.rows) do
				v:setvisibleatstart(false)
			end
		end
		
		
		
		
		--makes row objects
		
		level.rows = {}
		
		for i, v in ipairs(level.data.rows) do
            local oldroom = v.rooms[1]

            --v.rooms = level:roomtable(0)
            local newrow = level:getrow(v.row)
			newrow.nativeroom = oldroom
			
            setvalue(newrow, "room", 0, oldroom)
			if not beat then
				level:addfakeevent(0, "updaterowx", {row = v.row, duration = 0, ease = "Linear"})
				level:addfakeevent(0, "updaterowy", {row = v.row, duration = 0, ease = "Linear"})
				level:addfakeevent(0, "updaterowpivot", {row = v.row, duration = 0, ease = "Linear"})
			end
        end
		
		
		
		-- fake event handlers
		
		level:fakehandler('updaterowtint',function(self,v)
			self:addevent(
				v.beat,
				"TintRows",
				{
					row = v.row,
					border = getvalue(self.rows[v.row], "border", v.beat),
					borderColor = getvalue(self.rows[v.row], "bordercolor", v.beat),
					borderOpacity = getvalue(self.rows[v.row], "borderopacity", v.beat),
					tint = getvalue(self.rows[v.row], "tint", v.beat),
					tintColor = getvalue(self.rows[v.row], "tintcolor", v.beat),
					tintOpacity = getvalue(self.rows[v.row], "tintopacity", v.beat),
					opacity = getvalue(self.rows[v.row], "opacity", v.beat),
					duration = v.duration,
					ease = v.ease
				}, v._tag,v._cond
			)
		end)
		level:fakehandler('updaterowx',function(self,v)
			self:addevent(
				v.beat,
				"MoveRow",
				{
					row = v.row,
					target = "WholeRow",
					customPosition = true,
					rowPosition = {
						getvalue(self.rows[v.row], "x", v.beat) +
							(getvalue(self.rows[v.row], "room", v.beat) - self.rows[v.row].nativeroom) * 852.2727,
						null
					},
					duration = v.duration,
					ease = v.ease
				}, v._tag,v._cond
			)
		end)
		level:fakehandler('updaterowy',function(self,v)
			self:addevent(
				v.beat,
				"MoveRow",
				{
					row = v.row,
					target = "WholeRow",
					customPosition = true,
					rowPosition = {
						null,
						getvalue(self.rows[v.row], "y", v.beat)
					},
					duration = v.duration,
					ease = v.ease
				}, v._tag,v._cond
			)
		end)
		level:fakehandler('updaterowsx',function(self,v)
			self:addevent(
				v.beat,
				"MoveRow",
				{
					row = v.row,
					target = "WholeRow",
					customPosition = true,
					scale = {
						getvalue(self.rows[v.row], "sx", v.beat),
						null
					},
					duration = v.duration,
					ease = v.ease
				}, v._tag,v._cond
			)
		end)
		level:fakehandler('updaterowsy',function(self,v)
			self:addevent(
				v.beat,
				"MoveRow",
				{
					row = v.row,
					target = "WholeRow",
					customPosition = true,
					scale = {
						null,
						getvalue(self.rows[v.row], "sy", v.beat)
					},
					duration = v.duration,
					ease = v.ease
				}, v._tag,v._cond
			)
		end)
		level:fakehandler('updaterowrot',function(self,v)
			self:addevent(
				v.beat,
				"MoveRow",
				{
					row = v.row,
					target = "WholeRow",
					customPosition = true,
					angle = getvalue(self.rows[v.row], "rot", v.beat),
					duration = v.duration,
					ease = v.ease
				}, v._tag,v._cond
			)
		end)
		level:fakehandler('updaterowpivot',function(self,v)
			self:addevent(
				v.beat,
				"MoveRow",
				{
					row = v.row,
					target = "WholeRow",
					customPosition = true,
					pivot = getvalue(self.rows[v.row], "pivot", v.beat),
					duration = v.duration,
					ease = v.ease
				}, v._tag,v._cond
			)
		end)
		level:fakehandler('updaterowcx',function(self,v)
			self:addevent(
				v.beat,
				"MoveRow",
				{
					row = v.row,
					target = "Character",
					customPosition = true,
					rowPosition = {
						getvalue(self.rows[v.row], "cx", v.beat),
						null
					},
					duration = v.duration,
					ease = v.ease
				}, v._tag,v._cond
			)
		end)
		level:fakehandler('updaterowcy',function(self,v)
			self:addevent(
				v.beat,
				"MoveRow",
				{
					row = v.row,
					target = "Character",
					customPosition = true,
					rowPosition = {
						null,
						getvalue(self.rows[v.row], "cy", v.beat)
					},
					duration = v.duration,
					ease = v.ease
				}, v._tag,v._cond
			)
		
		end)
		level:fakehandler('updaterowcrot',function(self,v)
			self:addevent(
				v.beat,
				"MoveRow",
				{
					row = v.row,
					target = "Character",
					customPosition = true,
					angle = getvalue(self.rows[v.row], "crot", v.beat),
					duration = v.duration,
					ease = v.ease
				}, v._tag,v._cond
			)
		
		end)

		level:fakehandler('updaterowcsx',function(self,v)
			self:addevent(
				v.beat,
				"MoveRow",
				{
					row = v.row,
					target = "Character",
					customPosition = true,
					scale = {
						getvalue(self.rows[v.row], "csx", v.beat),
						null
					},
					duration = v.duration,
					ease = v.ease
				}, v._tag,v._cond
			)
		end)
		level:fakehandler('updaterowcsy',function(self,v)
			self:addevent(
				v.beat,
				"MoveRow",
				{
					row = v.row,
					target = "Character",
					customPosition = true,
					scale = {
						null,
						getvalue(self.rows[v.row], "csy", v.beat)
					},
					duration = v.duration,
					ease = v.ease
				}, v._tag,v._cond
			)
		end)
		level:fakehandler('updaterowhx',function(self,v)
			self:addevent(
				v.beat,
				"MoveRow",
				{
					row = v.row,
					target = "Heart",
					customPosition = true,
					rowPosition = {
						getvalue(self.rows[v.row], "hx", v.beat),
						null
					},
					duration = v.duration,
					ease = v.ease
				}, v._tag,v._cond
			)
		end)
		level:fakehandler('updaterowhy',function(self,v)
			self:addevent(
				v.beat,
				"MoveRow",
				{
					row = v.row,
					target = "Heart",
					customPosition = true,
					rowPosition = {
						null,
						getvalue(self.rows[v.row], "hy", v.beat)
					},
					duration = v.duration,
					ease = v.ease
				}, v._tag,v._cond
			)
		
		end)
		level:fakehandler('updaterowhrot',function(self,v)
			self:addevent(
				v.beat,
				"MoveRow",
				{
					row = v.row,
					target = "Heart",
					customPosition = true,
					angle = getvalue(self.rows[v.row], "hrot", v.beat),
					duration = v.duration,
					ease = v.ease
				}, v._tag,v._cond
			)
		
		end)

		level:fakehandler('updaterowhsx',function(self,v)
			self:addevent(
				v.beat,
				"MoveRow",
				{
					row = v.row,
					target = "Heart",
					customPosition = true,
					scale = {
						getvalue(self.rows[v.row], "hsx", v.beat),
						null
					},
					duration = v.duration,
					ease = v.ease
				}, v._tag,v._cond
			)
		end)
		level:fakehandler('updaterowhsy',function(self,v)
			self:addevent(
				v.beat,
				"MoveRow",
				{
					row = v.row,
					target = "Heart",
					customPosition = true,
					scale = {
						null,
						getvalue(self.rows[v.row], "hsy", v.beat)
					},
					duration = v.duration,
					ease = v.ease
				}, v._tag,v._cond
			)
		end)
		
		level:fakehandler('updaterowshow',function(self,v)
			self:addevent(
				v.beat,
				"HideRow",
				{
					row = v.row,
					show = v.show,
					transition = v.transition
				}, v._tag,v._cond
			)
		
		end)
		
		
		
		--add event type condensers
		
		level:condenser('MoveRow',function(self,elist)
			local condensed = {}
			local groups = self:getcondensable(elist,{
				'row',
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