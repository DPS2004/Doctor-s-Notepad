
level:setuprooms()

insom1 = level:newdecoration('insom', 0, 1)

insom1:movex(2, 75, 0.5, 'Linear')
insom1:movey(2.5, 30, 1, 'OutExpo')

insom1:movesx(3, 2, 1, 'InSine')
insom1:movesy(3.25, 1.5, 1, 'OutElastic')

insom1:setroom(4, 0)

insom1:movepx(1, 100, 1, 'OutBounce')

insom1:rotate(5, 360, 2, 'InBack')
insom1:rotate(7, 720, 2, 'OutExpo')

insom1:hide(10)
insom1:show(10.5)

insom1:playexpression(12, 'happy')

insom1:setborder(16, 'Outline', '000000', 100, 0, 'Linear')
insom1:setborder(16.5, 'Glow', 'FF0000', 100, 0, 'Linear')
insom1:setborder(17, 'Outline', '0000FF', 50, 0, 'Linear')
insom1:setborder(17.5, 'Glow', '00FF00', 50, 0, 'Linear')

insom1:settint(19, true, 'FFFF00', 100, 0.5, 'Linear')
insom1:settint(19.5, true, '0000FF', 0, 0.5, 'Linear')

insom1:setopacity(21, 50, 1, 'Linear')

insom1:move(13, {
	x = 50,
	y = 75,
	sx = 1
}, 2, 'InOutQuad')

insom1:movex(12, 65, 0.5, 'OutQuad')
insom1:movesy(12, 35, 0.5, 'OutQuad')

room0 = level.rooms[0]
room1 = level.rooms[1]

room0:settheme(0, 'InsomniacDay')
room1:settheme(0, 'BoyWard')

room0:move(0, {
	sx = 50,
	x = 25
}, 0, 'Linear')

room1:move(0, {
	sx = 50,
	x = 75
}, 0, 'Linear')

room0:move(15, {
	sx = 100,
	x = 50
}, 1, 'OutExpo')

row0 = level.rows[0]

row0:movesy(1, 2, 2, 'OutElastic')
row0:move(1.5, {
	csx = 0.5,
	csy = -1
}, 1, 'OutSine')
row0:move(3, {
	y = 75,
	x = 25
}, 1, 'OutQuad')
row0:move(4, {
	hx = -15,
	hy = -15,
	hrot = 90,
	hsx = 2,
	hsy = 4,
	yourmom = 5
}, 1, 'OutElastic')
