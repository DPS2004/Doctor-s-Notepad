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

level:getroom(4):floatingtext(3.5, 'Yo!\nYo, again!', {1}, 50, 50, 16)

level:setbg(18, 0, 'fg.png', 'image')
level:setbg(19, 0, '', 'image')

level:getroom(1):fade(19, 0, 1, 'OutExpo')

level:ontopsetbg(20, '', 'color', nil, nil, nil, nil, 'FFFFFFFF')
level:ontopsetbg(21, '', 'color', nil, nil, nil, nil, '000000FF')

level:ontopsetfg(22, 'fg.png', nil, nil, nil, nil, 'FFFFFFFF')
level:ontopsetfg(23, '', nil, nil, nil, nil, '000000FF')

level:pulsecamera(24, 0, 1, 2, 4)

level:ontopscreenscroll(26, true, 8, -2)

level:ontopflash(28, nil, nil, nil, 0, 1)

level:camx(1, 0, 25, 2, 'OutExpo')

level:movex(3, 0, 45, 2, 'OutExpo')
level:movey(3, 0, 55, 2, 'OutExpo')
