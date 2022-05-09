-- samuraiquest


level:setuprooms()

-- set row visibility
level.rows[1]:setvisibleatstart(false)
level.rows[2]:setvisibleatstart(false)
level.rows[3]:setvisibleatstart(false)

ontop = level.rooms[4]

-- room 0
mainroom = level.rooms[0]
mainroom:move(0,{x=50,y=50,sx=100,sy=100})

--	room 1
bg1 = level.rooms[1]
bg1:move(0,{x=150,y=50,sx=100,sy=100})

--	room 2
bg2 = level.rooms[1]
bg2:move(0,{x=50,y=50,sx=100,sy=100})


-- intro
bg2:settheme(0,'OrientalTechno')

level.rows[0]:move(0,{x=9,y=44,pivot=0,crot=90})
level.rows[0]:playexpression(0,'barely')
level.rows[0]:swapexpression(0,'happy','neutral')

mainroom:flash(0,'000000',100)
ontop:cam(0,{x=56,y=69,zoom=220})
mainroom:flash(0.01,'000000',100,'000000',0,6,'linear')

ontop:cam(0.01,{x=13,y=49,zoom=400},6,'inOutQuad')

level.rows[0]:playexpression(9,'neutral')