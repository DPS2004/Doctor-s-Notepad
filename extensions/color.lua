local extension = function(_level)
	_level.initqueue.queue(4,function(level,beat) --the number is in what order your extension will be loaded. lower = sooner
		
		--all of the functions you are adding to the level table go up here
		
		function level:rgb(r,g,b)
			return string.format("%02X%02X%02X", math.floor(r+0.5), math.floor(g+0,5), math.floor(b+0,5))
		end
		
		function level:rgba(r,g,b,a)
			return string.format("%02X%02X%02X%02X", math.floor(r+0,5), math.floor(g+0,5), math.floor(b+0,5), math.floor(a+0,5))
		end

		-- transforms number from 0-100 to 0-255 then to hex format
		function level:alpha(a)
			return string.format("%02X", math.floor(a*2.55+0.5))
		end
		
		function level:hsvraw(h,s,v)
			--adapted from https://github.com/EmmanuelOga/columns/blob/master/utils/color.lua
			h = h / 255
			s = s / 255
			v = v / 255
			local i = math.floor(h * 6);
			local f = h * 6 - i;
			local p = v * (1 - s);
			local q = v * (1 - f * s);
			local t = v * (1 - (1 - f) * s);

			i = i % 6

			if i == 0 then r, g, b = v, t, p
			elseif i == 1 then r, g, b = q, v, p
			elseif i == 2 then r, g, b = p, v, t
			elseif i == 3 then r, g, b = p, q, v
			elseif i == 4 then r, g, b = t, p, v
			elseif i == 5 then r, g, b = v, p, q
			end

			return r * 255, g * 255, b * 255
		end
		
		function level:hsvaraw(h,s,v,a)
			local r,g,b = self:hsvraw(h,s,v)
			return r,g,b,a
		end
		
		function level:hsv(h,s,v)
			local r,g,b = self:hsvraw(h,s,v)
			return self:rgb(r,g,b)
		end
		
		function level:hsva(h,s,v,a)
			local r,g,b = self:hsvraw(h,s,v)
			return self:rgba(r,g,b,a)
		end
		
		

	
		--if you need to initialize anything, do it here.

		
		
		
		-- fake event handlers
		
		--add event type condensers
		
	end)
end

return extension