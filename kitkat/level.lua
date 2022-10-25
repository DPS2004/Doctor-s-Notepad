-- hercelot - kit kat fat cat chat

-- clean up temporary vfx

level:clearevents({
  'MoveRoom',
  'ReorderRooms',
  'FadeRoom',
  'SetBackgroundColor',
  'SetRoomContentMode',
  'ShowStatusSign',
  'TintRows'
})

level:setuprooms()

-- set row visibility
level:hideallatstart()

-- room 0
mainroom = level.rooms[0]
mainroom:move(0,{x=100,y=50,sx=0,sy=100})

-- room 1
introroom = level.rooms[1]

--just to make it play a bit nicer with HOM
level:ccode(0,"shockwave(size,0)")

--intro
level:alloutline() -- give every row black outlines

introroom:move(0,{x=50,y=50,sx=100,sy=100})
introroom:settheme(0,'InsomniacDay')
introroom:sepia(0)
introroom:vhs(0)
introroom:aberration(0,true,25)
level.rows[1]:setroom(0,1)
level.rows[1]:show(0)


-- at beat 9, change rooms
mainroom:hom(8)

introroom:move(9,{x=0,y=50,sx=0,sy=100},2,'outExpo')
mainroom:move(9,{x=50,y=50,sx=100,sy=100},2,'outExpo')

level.rows[0]:show(0)

--ok time to really stress test the deco system :)

dropdecos = {}
local ddcount = 0
function kitkat_initdeco()
	local newdeco = level:newdecoration('square.png',0,0)
	newdeco:setvisibleatstart(false)
	dropdecos[ddcount] = newdeco
	ddcount = ddcount + 1
end

ddcolor = 0

dddirection = 1

function kitkat_dropdecos(beat,dstart,dend)
	
	beat = beat - 0.1
	for i=dstart,dend do
		local cdeco = dropdecos[i]
		local dropx = ((i - dstart) / (dend - dstart)) * 100
		cdeco:show(beat)
		local size = math.random(20,30)
		cdeco:settint(beat,true,level:hsv(ddcolor,255 - math.random(20),255 - math.random(20)))
		cdeco:move(beat,{x=dropx + math.random(-2,2),y=50 + (dddirection*100),sx = size, sy = size,rot=math.random(-360,360)})
		cdeco:move(beat,{x=dropx + math.random(-2,2),y=50 - (dddirection*100), rot=math.random(-360,360)},1 + (math.random(-4,4) / 20),'outSine')
	end
	ddcolor = ddcolor + 25
	dddirection = dddirection * -1
		
end

for i=0,19 do --initialize 20 decos
	kitkat_initdeco()
end

function multidrop(beat,variant)
	variant = variant or 0
	if variant == 0 then
		kitkat_dropdecos(beat,0,19)
		kitkat_dropdecos(beat+1.5,0,19)
		kitkat_dropdecos(beat+3,0,19)
		kitkat_dropdecos(beat+4.5,0,19)
		kitkat_dropdecos(beat+6,0,19)
	elseif variant == 1 then
		kitkat_dropdecos(beat,0,19)
		kitkat_dropdecos(beat+1.5,0,19)
		kitkat_dropdecos(beat+3,0,19)
		kitkat_dropdecos(beat+4.5,0,19)
		kitkat_dropdecos(beat+6,0,19)
		kitkat_dropdecos(beat+7,0,19)
	elseif variant == 2 then
		kitkat_dropdecos(beat,0,19)
		kitkat_dropdecos(beat+1.5,0,19)
		kitkat_dropdecos(beat+3,0,19)
		kitkat_dropdecos(beat+4,0,19)
		kitkat_dropdecos(beat+5.5,0,19)
		kitkat_dropdecos(beat+7,0,19)
	end
end
level:offset(9)
multidrop(0,0)
multidrop(8,1)
multidrop(16,0)
multidrop(24,2)

multidrop(32,0)
multidrop(40,1)
multidrop(48,0)
multidrop(56,2)
