-- various - randwich

-- clear everything but bpm and crotchets
level:clearevents({
	'SetBeatsPerMinute',
	'SetCrotchetsPerBar',
},true)

level:setuprooms()



-- room 0
mainroom = level.rooms[0]

bgroom = level.rooms[1]

oneshotrow = level.rows[0]
oneshotrow:setroom(0,3)
oneshotrow:setvisibleatstart(false)
oneshotrow:move(0,{x=-100,y=-100,pivot=0,rotate = -90})


---init rdcode stuff

-- for debugging, comment out during release
level:addevent(0,'PlaySong',{filename="song.ogg",volume=0,pitch=100,pan=0,offset=0,bpm=200,loop=false})
_FORCELEVEL = 2


_SANDWICHES = 2

if _FORCELEVEL then
	level:rdcode(0,'i1 = '.._FORCELEVEL) -- force level during testing
else
	level:rdcode(0,'i1 = Rand('.._SANDWICHES..')') --random number from 1 to _SANDWICHES
end
level:rdcode(0,'i1 = i1 * 5') -- each wich is 5 bars long
level:rdcode(0,'i1 = i1 - 3') --2,7,12,etc
level:rdcode(0,'SetNextBar(i1)')

sandwichbeat = 4
endbar = 2 + _SANDWICHES*5
level:ontopflash(0,'000000',100)



function newsandwich(bpm)
level:push(sandwichbeat)

mainroom = level.rooms[0]
bgroom = level.rooms[1]
oneshotrow = level.rows[0]

level:offset(sandwichbeat + 2)

-- work around for an rd bug
if sandwichbeat ~= 4 then
	level:addevent(-2,'SetCrotchetsPerBar',{crotchetsPerBar= 8, visualBeatMultiplier = 1})
end
level:setbpm(-2,bpm)
level:cue(-2)


--temp
level:addevent(0,'AddOneshotBeat',{row= 0, pulseType = "Wave", loops = 15, interval = 2, tick = 1})

level:ontopflash(0,'000000',0)

level:cue(31.5,'JustSayAnd')
level:cue(32,'JustSayStop')

level:ontopflash(32,'000000',0,'000000',100,4,'linear')

level:rdcode(32,'SetNextBar('..endbar..')')

sandwichbeat = sandwichbeat + 8*5
end

function endlevel()
	level:offset(0)
	level:finish(sandwichbeat,1)
end



-----------------------------csqn
newsandwich(174)

level:playsound(-2,'csqn_174.ogg',-35)

bgroom:setbg(-2,'csqn_stripes.png','Tiled',0,-100)

mainroom:move(0,{y=100,py = 100,sy = 200})
mainroom:setbg(-2,'csqn_sandwich.png')
mainroom:flash(0,'FCB000',100,'FCB000',0,2,'linear')
mainroom:screentile(0,1,2)
mainroom:screenscroll(0,0,10)
mainroom:pulsecamera(0,32)

for i=0,16,16 do 
	bgroom:movesy(i,400,8,'outSine')
	mainroom:movesy(i,100,8,'outSine')
	bgroom:movesy(i+8,100,8,'outSine')
	mainroom:movesy(i+8,200,8,'outSine')
end
for i=0,36 do
	mainroom:xflip(i)
end

-----------------------------okultra
newsandwich(161)

level:playsound(-2,'okultra_161.ogg',30)

level:reorderrooms(-2,2,0,1,3)

function okultra_bg(beat)
	for i=0,3 do
		
		bgroom:setbg(i*2+beat,'okultra_bg.png','Tiled',10,10,'441137FF')
		bgroom:camrot(i*2+beat,1,0)
		bgroom:camrot(i*2+beat,0,1,'OutQuad')
		
		bgroom:setbg(i*2+1+beat,'okultra_bg.png','Tiled',10,10,'112744FF')
		bgroom:camrot(i*2+1+beat,-1,0)
		bgroom:camrot(i*2+1+beat,0,1,'OutQuad')
		
		
	end
end

for i=0,36 do
	mainroom:move(i,{sy=100,sx=100},0.5,'outExpo')
	mainroom:movey(i,55,0.5,'outSine')
	mainroom:move(i+0.5,{y=50,sy=95,sx=105},0.5,'inSine')
end

for i=0,34,2 do
	mainroom:movesx(i,100,1,'outExpo')
	mainroom:movesx(i+0.5,105,0.5,'inSine')
	mainroom:movesx(i+1,-100,1,'outExpo')
	mainroom:movesx(i+1.5,-105,0.5,'inSine')
end

mainroom:setbg(-2,'okultra_sandwich.png')

level.rooms[2]:grain(0)
bgroom:pulsecamera(0,36,1,0)
bgroom:setbg(0,'okultra_bg.png','Tiled',10,10,'112744FF')
okultra_bg(0.5)
okultra_bg(8)
okultra_bg(16.5)
okultra_bg(24)




for i=0,36 do
	
end




---------------------------end
endlevel()