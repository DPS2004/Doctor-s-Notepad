-- birdcarry


level:setuprooms()

level:reorderrooms(0,1,0,2,3)

-- set up rows
bird = level.rows[0]
samurai = level.rows[1]

samurai:showchar(0)
bird:showchar(0)

bird:move(0,    {x=30-2.5,y=48, cy = 5,  cx = -2, sx=0.75, sy=0.75, csx = 1.1, csy = 1.1, crotate = 90,rotate = -90, pivot=0})
samurai:move(0, {x=0+2.5 ,y=48, cy = -5, cx = -2, sx=0.75, sy=0.75, csx = 1.1, csy = 1.1, crotate =450,rotate = -90, pivot=0})

level:alloutline()

-- set up rooms
ontop = level.rooms[4]

-- character room
chroom = level.rooms[0]
chroom:move(0,{x=50,y=50,sx=100,sy=100})
level:rdcode(0,'i1 = Rand(2)','OnPrebar')
flipcheck = level:newconditional('flipcheck','i1 == 1')

level:conditional(flipcheck)
	chroom:xflip(0.01)
level:endconditional()

--	particles room
proom = level.rooms[1]
proom:move(0,{x=50,y=50,sx=100,sy=100})

proom:snow(0)
level:speed(0,0.25,true)
proom:yflip(0)
proom:fade(0,50)

--	bg room
bgroom = level.rooms[2]
bgroom:move(0,{x=50,y=50,sx=100,sy=100})

bgroom:setbg(0,'bg.png','Image',nil,'AspectFit')



-- intro

ontop:flash(0,'000000',100)
ontop:flash(0.01,'000000',100,'000000',0,1)

samurai:move(0.01, {x=20+2.5,crotate = 90},1.2,'outSine')

level:dialog(1,'[fast]* (This little bird wants to carry you across.)',false)
level:dialog(3.75,'[fast]* (Accept the bird\'s offer?)    [normal]   [fast]<3 Get ride     No',false)

level:hidedialog(6.5)
samurai:show(6.5,true)
bird:show(6.5,true)

--generate shakes
--i thought about generating these with Rand(), but then i remembered sort offset exists.
level:offset(83)

level:tag('doShake')
	for i=0,16,0.05 do
		bird:move(i,{cx = -2 + (math.random(10,-10)/20), cy= 5 +(math.random(10,-10)/20)})
		samurai:move(i,{cx = -2 + (math.random(10,-10)/20), cy= -5 +(math.random(10,-10)/20)})
	end
level:endtag()

--main



level:offset(7)

bird:swapexpression(0,'Neutral','flying')
bird:swapexpression(0,'Missed','flyingSad')
bird:swapexpression(0,'Happy','flyingHappy')
bird:swapexpression(0,'Barely','flyingSad')

bird:move(0,{x=20-2.5,y=56},2.1,'linear')
bird:move(2.2,{csx=-1.1},1,'inOutSine')




bird:move(0,{rotate=-80,crotate = 80},2,'outSine')
bird:move(2,{rotate=-90,crotate = 90},3,'outSine')


bird:move(3.5,{y=81},12.5,'linear')
samurai:move(4,{y=74},12,'linear')

level:runtag(4,'doShake')

bird:move(16,{x=80-2.5},38,'linear')
samurai:move(16,{x=80+2.5},38,'linear')

bird:move(16,{rotate = (-103),crotate = 103},6,'outSine')
samurai:move(16,{rotate = (-106),crotate = 106},6,'outSine')

for i=6,38,4 do
	local birdr = math.random(100,110) + (i/3) + 2
	local samurair = math.random(100,110) + (i/3) - 2
	bird:move(i+16,{rotate = (0-birdr),crotate = birdr},math.random(30,40)/10,'inOutSine')
	samurai:move(i+16,{rotate = (0-samurair),crotate = samurair},math.random(30,40)/10,'inOutSine')
end


level:runtag(20,'doShake')
level:runtag(36,'doShake')

--finish
level:offset(61)

level:runtag(-3.5,'doShake')

bird:move(0,{y=56},12.5,'linear')


bird:move(0,{rotate=-90,crotate = 90},8,'outSine')
samurai:move(0,{rotate=-90,crotate = 90},8,'outSine')

samurai:move(0,{y=48},12,'linear')

samurai:showchar(8,true)
bird:showchar(8,true)


bird:move(12.6,{csx=1.1},0.3,'inOutSine')
bird:move(12.7,{x=70-2.5},0.8,'linear')

samurai:move(13,{csx=-1.1},0.3,'inOutSine')

bird:move(13.4,{csx=-1.1},0.3,'inOutSine')
bird:move(13.5,{y=48},0.7,'linear')

bird:swapexpression(14.2,'Neutral','Neutral')
bird:playexpression(14.75,'happy')
samurai:playexpression(14.75,'happy')

samurai:move(14.75,{y=54},0.2,'outSine')
samurai:move(14.95,{y=48},0.2,'inSine')
samurai:move(15.15,{y=56},0.2,'outSine')
samurai:move(15.15,{csx=1.1},0.3,'inOutSine')
samurai:move(15.35,{y=48},0.2,'inSine')
samurai:move(15.55,{x=120,crotate=-360},1,'inSine')