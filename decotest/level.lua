level:setuprooms()

level:getroom(1):settheme(0, 'BoyWard')
level:getroom(1):mask(0, 'fg.png')
level:getroom(1):mask(2, {'fg.png', 'fg2.png'}, 4)
level:getroom(1):mask(4, '')

-- same thing as level:getroom(0):screentile(2, true, 2, nil) (actually literally just that haha)
level:screentile(2, 0, true, 2, nil)

level:getroom(0):screentile(4, true, 1, 1)

-- same thing as level:getroom(4):screenscroll(4, true, -2, 5) (actually literally just that haha)
level:ontopscreenscroll(6, true, 0, 2)

-- same thing as level:getroom(0):sepia(6, true)
level:sepia(8, 0, true)

-- same thing as level:getroom(0):sepia(8), this should toggle sepia to be false
level:sepia(10, 0)

-- same thing as level:getroom(4):sepia(9) and level:sepia(9, 4), this should toggle on-top sepia to be true
level:ontopsepia(12)

-- set on-top sepia to false
level:ontopsepia(14, false)

for i=0,7 do

	local str = tostring(level:getroom(0):getpreset(i, 'screentile')) .. ', ' .. tostring(level:getroom(0):getpreset(i, 'screentile', 'floatx'))

	level:comment(i, str)
end

level:vignette(16, 0)

level:ontopscreenscroll(16, true, 0, 0)

level:getroom(0):setperspective(18, {
	{100, 0}, {100, 100}, {0, 0}, {0, 100}
}, 2, 'OutElastic')

local corners = getvalue(level:getroom(0), 'corners', 20)
local str = ''

for _,c in ipairs(corners) do
	str = str .. '{' .. c[1] .. ', ' .. c[2] .. '}, '
end

level:comment(20, str:sub(1,-3))

local corners = getvalue(level:getroom(0), 'corners', 1)
local str = ''

for _,c in ipairs(corners) do
	str = str .. '{' .. c[1] .. ', ' .. c[2] .. '}, '
end

level:comment(21, str:sub(1,-3))
