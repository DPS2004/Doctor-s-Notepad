level:setuprooms()

mycoolroom = level:getroom(0)

mycoolroom:rain(2, true, 50, 2, 'InOutQuad')

mycoolroom:floatingtext(3.5, 'Yo!\nYo, again!\nwoo', {1, 3}, 50, 50, 16, 0, 'FadeOut', true, 'ff0000', '0000ff', 'MiddleCenter', 2)

-- same thing as level:getroom(0):screentile(2, true, 2, nil)
level:screentile(2, 0, true, 3, 4)

level:getroom(0):screentile(4, true, 1, 1)

-- same thing as level:getroom(0):sepia(6, true)
level:sepia(6, 0, true)

-- same thing as level:getroom(0):sepia(8), this should toggle sepia to be false
level:sepia(8, 0)

-- same thing as level:getroom(4):sepia(10) and level:sepia(10, 4), this should toggle on-top sepia to be true
level:ontopsepia(10)

-- set on-top sepia to false
level:ontopsepia(12, false)

for i = 0, 7 do

	local str = tostring(level:getroom(0):getpreset(i, 'screentile')) .. ', ' .. tostring(level:getroom(0):getpreset(i, 'screentile', 'floatx'))

	level:comment(i, str)

end
