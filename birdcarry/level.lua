-- birdcarry


level:setuprooms()

-- set up rows
samurai = level.rows[0]
bird = level.rows[1]

samurai:showchar(0)
bird:showchar(0)

level:alloutline()

-- set up rooms
ontop = level.rooms[4]

-- character room
chroom = level.rooms[0]
chroom:move(0,{x=50,y=50,sx=100,sy=100})

--	particles room
proom = level.rooms[1]
proom:move(0,{x=50,y=50,sx=100,sy=100})

--	bg room
bgroom = level.rooms[2]
bgroom:move(0,{x=50,y=50,sx=100,sy=100})

bgroom:setbg(0,'bg.png')

-- intro


ontop:flash(0,'000000',100)
ontop:flash(0.01,'000000',100,'000000',0,1,'linear')
