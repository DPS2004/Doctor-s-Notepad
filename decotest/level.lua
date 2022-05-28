level:setuprooms()

level:getroom(1):settheme(0, 'BoyWard')

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
	level:comment(i, tostring(level:getroom(0):getpreset(i, 'screentile')))
	level:comment(i, tostring(level:getroom(0):getpreset(i, 'screentile', 'floatx')))
end