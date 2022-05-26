-- samuraiquest


level:setuprooms()

level:reorderrooms(0,3,0,1,2)

-- set row visibility
level.rows[1]:setvisibleatstart(false)
level.rows[2]:setvisibleatstart(false)
level.rows[3]:setvisibleatstart(false)

level.rows[0]:showchar(1)

clschick = level.rows[4]

clschick:setvisibleatstart(false)
clschick:move(0,{x=199,y=90,pivot=0})

ontop = level.rooms[4]

-- room 0
mainroom = level.rooms[0]
mainroom:move(0,{x=50,y=50,sx=100,sy=100})

--	room 1
bg1 = level.rooms[1]
bg1:move(0,{x=50,y=50,sx=100,sy=100})

--	room 2
bg2 = level.rooms[2]
bg2:move(0,{x=150,y=50,sx=100,sy=100})


-- intro
bg1:settheme(0,'OrientalTechno')

level.rows[0]:move(0,{x=9,y=44,pivot=0,crot=90})
level.rows[0]:playexpression(0,'barely')
level.rows[0]:swapexpression(0,'happy','neutral')

mainroom:flash(0,'000000',100)
ontop:cam(0,{x=56,y=69,zoom=220})
mainroom:flash(0.01,'000000',100,'000000',0,6,'linear')

ontop:cam(0.01,{x=13,y=49,zoom=400},6,'inOutQuad')

level.rows[0]:playexpression(9,'neutral')

level.rows[0]:move(9.5,{crot=0,y=30},1,'inOutSine')
ontop:camzoom(9.5,100,1.25,'outQuad')
ontop:cam(9.5,{x=50,y=50},1,'outSine')

level.rows[0]:show(11,true)

bg1:move(12,{x=-50,y=50},16)

function brodywalk(beat,rowid,y)
	y = y or 30
	level.rows[rowid]:move(beat,{crot=-15,cx=1,y=y-2},0.25,'linear')
	level.rows[rowid]:move(beat+1,{crot=0,cx=0,y=y},0.25,'linear')
	level.rows[rowid]:move(beat+2,{crot=15,cx=-1,y=y-2},0.25,'linear')
	level.rows[rowid]:move(beat+3,{crot=0,cx=0,y=y},0.25,'linear')
end

curroom = 1
curbeat = -4

function newroom(func)
	curbeat = curbeat + 16
	curroom = curroom + 1
	if curroom >= 3 then
		curroom = 1
	end
	local room = level.rooms[curroom]
	room:move(curbeat,{x=150,y=50})
	room:move(curbeat,{x=-50,y=50},32,'linear')
	func(room,curbeat)
end




for i=12,128,4 do
	brodywalk(i,0,30)
end

newroom(function(room,curbeat)
	room:settheme(curbeat,'HospitalWard')
end)
newroom(function(room,curbeat)
	room:settheme(curbeat,'BoyWard')
end)
newroom(function(room,curbeat)
	room:settheme(curbeat,'Garden')
end)
newroom(function(room,curbeat)
	room:settheme(curbeat,'BackAlley')
end)
newroom(function(room,curbeat)
	room:settheme(curbeat,'CoffeeShop')
end)
newroom(function(room,curbeat)
	room:settheme(curbeat,'InsomniacDay')
end)
newroom(function(room,curbeat)
	room:settheme(curbeat,'Basement')
	clschick:showchar(curbeat)
	clschick:move(curbeat,{x=-101},48,'linear')
end)
