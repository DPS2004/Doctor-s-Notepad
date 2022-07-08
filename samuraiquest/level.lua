-- samuraiquest


level:setuprooms()

level:reorderrooms(0,3,0,1,2)

-- set row visibility
level.rows[1]:setvisibleatstart(false)
level.rows[2]:setvisibleatstart(false)
level.rows[3]:setvisibleatstart(false)

level.rows[0]:showchar(1)




----decos
clschick = level:newdecoration('clschick',0,3,'clschick')

clschick:setvisibleatstart(false)
clschick:move(0,{x=199,y=85,pivot=0})

pressspace = level:newdecoration('pressspace.png',0,3,'pressspace')

pressspace:setvisibleatstart(false)
pressspace:move(0,{x=150,y=50,pivot=0})

chirpbg = level:newdecoration('chirp.png',0,3,'chirpbg')

chirpbg:setvisibleatstart(false)
chirpbg:move(0,{x=150,y=50,pivot=0})

doctah = level:newdecoration('doctah',0,3,'doctah')

doctah:setvisibleatstart(false)
doctah:move(0,{x=140,y=30,pivot=0})

mb_car = level:newdecoration('car1.png',0,3,'mb_car')

mb_car:setvisibleatstart(false)
mb_car:move(0,{x=150,y=50,pivot=0})

owl = level:newdecoration('pools_owl',0,3,'pools_owl')

owl:setvisibleatstart(false)
owl:move(0,{x=15,y=150,pivot=0})

arra = level:newdecoration('arra',0,3,'arra')

arra:setvisibleatstart(false)
arra:move(0,{x=170,y=120,pivot=0,rot=180})

ghosturai = level:newdecoration('SamGhost',0,3,'ghosturai')

ghosturai:setvisibleatstart(false)
ghosturai:move(0,{x=150,y=50,pivot=0})

jag_hailey = level:newdecoration('haileyold',0,1,'haileyold')

jag_hailey:setvisibleatstart(false)
jag_hailey:move(0,{x=-20,y=50,pivot=0})

jag_bb = level:newdecoration('bb',0,1,'bb')

jag_bb:setvisibleatstart(false)
jag_bb:move(0,{x=120,y=50,pivot=0})

jag_fireball = level:newdecoration('brodyball.png',0,1,'fireball')

jag_fireball:setvisibleatstart(false)
jag_fireball:move(0,{x=200,y=50,sx=0.5,sy=0.5,pivot=0})

panda = level:newdecoration('panda',0,2,'panda')
panda:setvisibleatstart(false)
               --what why though
panda:move(0,{x=42.89773, y=21.21212})
bamboos = {}
for i=0,7 do
	local newdeco = level:newdecoration('bamboo',0,2,'bamboo_'..i)
	newdeco:setvisibleatstart(false)
	newdeco:move(0,{x=50,y=20.20*(i+1)})
	bamboos[i] = newdeco
end
	

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

endwalk = 616

function brodywalk(beat,rowid,y,scale)
	y = y or 30
	scale = scale or 1
	level.rows[rowid]:move(beat,{crot=-15*scale,cx=1*scale,y=y-2},0.25,'linear')
	level.rows[rowid]:move(beat+1,{crot=0,cx=0,y=y},0.25,'linear')
	level.rows[rowid]:move(beat+2,{crot=15*scale,cx=-1*scale,y=y-2},0.25,'linear')
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




for i=12,endwalk,4 do
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
	clschick:show(curbeat)
	clschick:move(curbeat,{x=-101},48,'linear')
	level.rooms[3]:wavyrows(curbeat)
	clschick:playexpression(curbeat+30,'happy')
	clschick:hide(curbeat+48)
end)
newroom(function(room,curbeat)
	level:comment(curbeat+12,'Peaceful Seabed\nsoggoru waffle')

	level.rows[1]:move(curbeat-1,{x=112,y=20,crot=-600,pivot=0})
	level.rows[1]:show(curbeat)
	
	level.rows[1]:move(curbeat+12,{x=12,crot=0},4,'inSine')
	
	room:settheme(curbeat,'None')
	
	pressspace:show(curbeat)
	pressspace:move(curbeat,{x=-50},32)
	pressspace:move(curbeat+12,{y=100},2,'outQuad')
	pressspace:hide(curbeat+32)
	
	room:showhand(curbeat,'Right',true)
	room:hidehand(curbeat + 11)
	
	
	room:flash(curbeat+12,'000000',100,'000000',0,2,'linear')
	for i=12,15,2 do
		room:setbg(curbeat + i,'seabed_0.png')
		room:setbg(curbeat + i+1,'seabed_1.png')
	end
	for i=16,31,4 do
		room:setbg(curbeat + i,'seabed_2.png')
		room:setbg(curbeat + i+1,'seabed_3.png')
		room:setbg(curbeat + i+2,'seabed_4.png')
		room:setbg(curbeat + i+3,'seabed_5.png')
	end
	
	for i=curbeat+16,endwalk,4 do
		brodywalk(i,1,24,-1)
	end
	
end)
newroom(function(room,curbeat)
	level:reorderrooms(curbeat,0,3,1,2)
	level:comment(curbeat+8,'Chirp\nNocallia & Xeno')
	
	level:finalize()
		room:settheme(curbeat,'none')
		room:rain(curbeat,true)
	level:endfinalize()
	
	chirpbg:show(curbeat)
	chirpbg:move(curbeat,{x=-50},32)
	chirpbg:hide(curbeat+32)
	room:rain(curbeat+32,false)
	
	
end)
newroom(function(room,curbeat)
	
	level:comment(curbeat+8,'Laidback Thrills\nSzprycha')
	room:settheme(curbeat,'CrossesFalling')
	room:setbg(curbeat,'laidback.png')
	
	doctah:show(curbeat)
	doctah:move(curbeat,{x=-160},48,'linear')
	doctah:playexpression(curbeat+17.5,'happy')
	doctah:hide(curbeat+48)
	
	
	
end)
newroom(function(room,curbeat)
	
	level:comment(curbeat+8,'Mulberry Street\nMarioMak967')
	room:settheme(curbeat,'none')
	room:setbg(curbeat,'mulberry.png')
	--room:pulsecamera(curbeat,16,2,0)
	
	mb_car:show(curbeat+15.5)
	mb_car:move(curbeat+15.5,{x=-50},0.5,'linear')
	mb_car:hide(curbeat+16)
	
	
	
end)

newroom(function(room,curbeat)
	level:reorderrooms(curbeat,3,0,1,2)
	level:alloutline(curbeat,'000000',50,16,'linear')
	
	level:comment(curbeat+8,'Pools\nTimeshark')
	
	room:setbg(curbeat,'jungy.png')
	
	level:finalize()
		room:settheme(curbeat,'none')
		room:bloom(curbeat, true, 0.3, 2, 'D7A300')
		room:vignetteflicker(curbeat, true)
	level:endfinalize()
	--room:pulsecamera(curbeat,16,2,0)
	
	owl:settint(curbeat,true,'000000')
	owl:setborder(curbeat,'Glow','000000',56)
	owl:show(curbeat)
	level.rows[2]:show(curbeat)
	level.rows[2]:move(curbeat,{x=15,y=140,pivot=0})
	
	owl:move(curbeat+15,{y=28},1,'outSine')
	level.rows[2]:move(curbeat+15,{y=18},1,'outSine')
	owl:move(curbeat+16,{y=150},1,'inSine')
	owl:hide(curbeat+17)
	for i=curbeat+16,endwalk,4 do
		brodywalk(i,2,18)
	end
	
end)


newroom(function(room,curbeat)
	
	level:comment(curbeat+8,'Momotaro\nCV35W')
	room:setbg(curbeat,'ShojiBG.png')
	
	arra:move(curbeat,{x=-130},48,'linear')
	
	arra:show(curbeat+13)
	arra:move(curbeat+13,{y=90},1,'outQuad')
	
	arra:move(curbeat+25,{sx=-1},1,'inOutSine')
	
	room:floatingtext(curbeat+26.5,'???',nil,80,77,8,180,nil,true,'ffffffff','000000ff',nil,nil,5.5) --this... could be better
	
	arra:hide(curbeat+48)
	
	
end)

newroom(function(room,curbeat)
	
	level:comment(curbeat+8,'Luna Ascension EX\nSome J Name, Het, DPS2004, Samario')
	
	room:bloom(curbeat, false)
	room:vignetteflicker(curbeat, false)
	room:setbg(curbeat,'lunabg.png','Image',30,'Tiled',-100,0)
	room:setfg(curbeat,'lunafg.png')
	
	
end)

newroom(function(room,curbeat)
	
	level:comment(curbeat+8,'Something Divine\nauburnsummer & Xeno')
	room:setbg(curbeat,'UtilityPoles_Dark.png')
	room:vignette(curbeat, true)
	room:bloom(curbeat, true, 0, 3, '3E2397')
	
	level.rooms[3]:bloom(curbeat+7, true, 0, 3, '3E2397')
	level.rooms[3]:fade(curbeat+7,0)
	
	ghosturai:move(curbeat,{x=-50},32)
	
	ghosturai:show(curbeat+7.5)
	ghosturai:setborder(curbeat+7.5,'Glow','BB88EE',60)
	ghosturai:settint(curbeat+7.5,true,'BB88EE',20)
	
	level.rooms[3]:fade(curbeat+10,50,4,'outQuad')
	level.rooms[3]:fade(curbeat+20,0,4,'outQuad')
	level.rooms[3]:fade(curbeat+25,100)
	
	room:setbg(curbeat+16,'UtilityPoles_1.png')
	room:setbg(curbeat+16.2,'UtilityPoles_2.png')
	room:setbg(curbeat+16.4,'UtilityPoles_3.png')
	room:setbg(curbeat+16.6,'UtilityPoles_4.png')
	room:setbg(curbeat+16.8,'UtilityPoles_Night.png')
	
	ghosturai:hide(curbeat+32)
	
	
	
	
	
end)

newroom(function(room,curbeat)
	
	level:comment(curbeat+8,'Superhero Jagganath\nauburnsummer')
	
	room:vignette(curbeat, true)
	room:setbg(curbeat,'ominious_tower.png')
	room:setfg(curbeat,'empty.png')
	room:cutscene(curbeat+8, true)
	
	room:cutscene(curbeat+16, false)
	
	
	jag_hailey:show(curbeat+8)
	jag_hailey:setborder(curbeat+8,'Glow','FFFFFF',100)
	
	jag_hailey:move(curbeat+8, {x=30},2,'outQuad')
	
	jag_bb:show(curbeat+10)
	jag_bb:setborder(curbeat+10,'Glow','FF495C',100)
	
	jag_bb:move(curbeat+10, {x=70},2,'outQuad')
	
	jag_fireball:show(curbeat+12)
	jag_fireball:move(curbeat+12,{x=-100},2,'linear')
	
	jag_hailey:move(curbeat+12.5,{x=-20,y=90,rot=1000},1,'linear')
	
	jag_hailey:hide(curbeat+13.5)
	jag_fireball:hide(curbeat+14)
	jag_bb:hide(curbeat+28)
end)

newroom(function(room,curbeat)
	
	level:comment(curbeat+8,'吾夜犹明\nbamboo')
	room:setbg(curbeat,'bamboo_bg.png')
	room:vignette(curbeat, false)
	room:bloom(curbeat, false, 0, 3, '3E2397')
	
	level.rooms[3]:bloom(curbeat, false, 0, 3, '3E2397')
	
	panda:show(curbeat)
	for i=0,31 do
		panda:playexpression(curbeat+i,'happy')
	end
	
	local bamboo_hits = 
	{0,1,0,1,0,1,0,1,
	 1,1,0,1,0,1,0,1,
	 1,1,0,1,0,1,0,1,
	 1,1,0,1,0,1,0,1
	}
	
	for k,v in pairs(bamboos) do
		v:show(curbeat)
	end
	
	
	for i,v in ipairs(bamboo_hits) do
		local bamb_num = i - 1
		local piece_num = bamb_num % 8
		local piece = bamboos[piece_num]
		local expr = 'neutral'
		if v == 1 then
			expr = 'happy'
		end
		local cb = curbeat + bamb_num
		piece:playexpression(cb-7,expr)
		
		piece:move(cb-7,{y=8*20.20,x=50,rot=0},0,'linear')
		for _i = 1,6 do
			piece:move(cb-(7-_i),{y=(7-_i)*20.20,x=50,rot=0},1,'inSine')
		end
		piece:move(cb,{x=150,y=20.20,rot=-1000},0.75,'linear')
	end
	
	
	
	
	
end)


-- pixel plantation


-- 吾夜犹明 - bamboo
--(1 insine for falling pieces, to 20.20 * height)
--panda swings for 0.5 of a beat, then goes back



--levels to find a place for:

--Madness - Samario

--Marble Forest - donte

-- and lots others