
--[[
local colors = {
	{'DA1A3E', 'C01535'}, -- red
	{'E3E477', 'C1C163'}, -- yellow
	{'96E16B', '7EBE59'}, -- green
	{'DEAD42', 'BB8F32'}, -- orange
	{'2E21E3', '2419BE'}, -- blue
	{'9E00A8', '850090'}, -- purple
	{'E1A7B2', 'BE8B94'}  -- pink
}
]]

local colors = {
	{level:rgb(200, 0, 0), level:rgb(100, 0, 0)}, -- red
	{level:rgb(200, 200, 0), level:rgb(100, 100, 0)}, -- yellow
	{level:rgb(0, 200, 0), level:rgb(0, 100, 0)}, -- green
	{level:rgb(200, 100, 0), level:rgb(100, 50, 0)}, -- orange
	{level:rgb(0, 0, 200), level:rgb(0, 0, 100)}, -- blue
	{level:rgb(200, 0, 200), level:rgb(100, 0, 100)}, -- purple
	{'E1A7B2', 'BE8B94'}, -- pink
}

local function tobeat(bar, beat)
	return (bar - 1) * 4 + beat - 1
end

local syncos = {}
local pulses = {
	0, 46,
	48, 78, 
	tobeat(41, 1), tobeat(48, 3)
}

local room0 = level:getroom(0)
local row0 = level:getrow(0)
local row1 = level:getrow(1)

for i = 1, #level.data.events do

	local e = level.data.events[i]

	if e.type == 'TintRows' and e.row == 0 then

		local trueBeat = tobeat(e.bar, e.beat)
		local idx = math.floor(trueBeat) % #colors + 1

		local isPulse = false
		local j = 1

		for beat = 0, trueBeat do

			if beat >= (pulses[j] or 99999) then
				isPulse = not isPulse
				j = j + 1
			end

		end

		if isPulse then
			e.tint = true
			e.tintColor = colors[idx][1]
		end

		table.insert(syncos, trueBeat)

	end

end

local j = 1
local isSynco = false

local j2 = 1
local isPulse = false

for beat = 0, 99*4 do

	if beat >= (pulses[j2] or 99999) then
		isPulse = not isPulse
		j2 = j2 + 1
	end

	if beat >= (syncos[j] or 99999) then
		isSynco = not isSynco
		j = j + 1
	end

	if isPulse then

		local i = beat % #colors + 1

		level:rdcode(beat + 0.01, ('RunTag(str:%s)'):format('room2_zoom'))

		if isSynco then
			-- row0:settint(beat, true, colors[i][1], 100, 0, 'Linear')
			-- row0:setborder(beat, 'Outline', 'FFFF00', 100, 0, 'Linear')
			level:addevent(beat, 'TintRows', {
				row = 0,
				border = 'Outline',
				borderColor = 'FFFF00',
				borderOpacity = 100,
				tint = true,
				tintColor = colors[i][1],
				tintOpacity = 100
			})
		else
			level:addevent(beat, 'TintRows', {
				row = 0,
				border = 'None',
				borderColor = 'FFFF00',
				borderOpacity = 100,
				tint = true,
				tintColor = colors[i][1],
				tintOpacity = 100
			})
			-- row0:settint(beat, true, colors[i][1], 100, 0, 'Linear')
			-- row0:setborder(beat, 'Outline', 'FFFF00', 100, 0, 'Linear')
		end
		room0:setbg(beat, nil, 'Color', nil, nil, nil, nil, colors[i][2])

	end

end
