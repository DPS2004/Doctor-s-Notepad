-- startingline


level.data.settings.mods = nil
level.data.settings.firstBeatBehavior = 'RunEventsOnPrebar'


level:setuprooms()

level:reorderrooms(0,1,0,2,3)

-- set row visibility
--level:hideallatstart()


bg = level:newdecoration('bg.png',0,3,'bg')
bg:move(0,{x= (-3 * 2.5),y=50,px=0,py=50})

bg2 = level:newdecoration('bg.png',0,3,'bg2')
bg2:move(0,{x= (-3 * 2.5)+(1056*(100/352)),y=50,px=0,py=50})

start_front = level:newdecoration('start_front.png',-1000,0,'start_front')
start_back = level:newdecoration('start_back.png',10,0,'start_back')

end_front = level:newdecoration('start_front.png',-1000,0,'end_front')
end_back = level:newdecoration('start_back.png',10,0,'end_back')
end_front:move(0,{x=460})
end_back:move(0,{x=460})


leaderx = 0
leaderbeat = 0
leadderrow = 0

rowy = {}
rowshown = {}

for i=0,10 do
	rowy[i] = i
	level.rows[i]:move(0,{pivot=0,x=20 - i*1.3,y=45 - (i * 2.75),sx=0.8,sy=0.8})
	rowshown[i] = false
	if i ~= 0 then
		level.rows[i]:showchar(0,0)
	end
end
rowshown[0] = true

level:alloutline() -- give every row black outlines

movequeue = deeper.init()

local cammult = (352/100)*2.5

level:ccode(0,'trueCameraMove(0, '..-3 * cammult..', 0, 0, outExpo)')
level:ccode(0,'trueCameraMove(3, '..-3 * cammult..', 0, 0, outExpo)')

function moverow(row,beat,y)
	
	if not rowshown[row] then
		level.rows[row]:show(beat,1)
		rowshown[row] = true
	end
	
	if beat ~= leaderbeat then
		leaderx = leaderx + 1
		level:ccode(beat,'trueCameraMove(0, '..(leaderx-3) * cammult..', 0, 2, outExpo)')
		level:ccode(beat,'trueCameraMove(3, '..(leaderx-3) * cammult..', 0, 2, outExpo)')
	end
	leaderbeat = beat
	local length = 1
	if leadderrow ~= row then
		length = 2
	end
	leadderrow = row
	level.rows[row]:move(beat,{x= (20 - row*1.3) + leaderx*2.5},length,'outExpo')
	print((20 - row*1.3) + leaderx*2.5)
	if y then
		level.rows[row]:move(beat,{y = 45 - (y * 2.75)},1,'outExpo')
	end
	
end



function hiderows(beat,rows)
	movequeue.queue((beat)*100,function()
		for i,v in ipairs(rows) do
			level.rows[v]:showchar(beat,1)
			rowshown[v] = false
		end
	end)
	
end

function baselyricsfunc(beat,row,text,timing,fade,duration,repeats,y)
	repeats = repeats or 1
	for i=0,repeats-1 do
		movequeue.queue((beat+(i*duration))*100,function()
			moverow(row,beat+(i*duration),y)
			if fade ~= 0 then
				level.rooms[1]:floatingtext(beat+(i*duration),text,
				timing,50,95 - (rowy[row]*5) ,nil,nil,nil,nil,nil,nil,nil,fade)
			end
		end)
	end
end

function justlyrics(beat,row,text,timing,fade)
	movequeue.queue((beat)*100,function()
		level.rooms[1]:floatingtext(beat,text,
		timing,50,95 - (rowy[row]*5) ,nil,nil,nil,nil,nil,nil,nil,fade)
	end)
end


function thisisthestoryofagirl_first(beat,repeats,y)
	baselyricsfunc(beat,0,
	'This/ is/ the/ sto/ry/ of/ a/ girl.',
	{0.3333, 3.4167, 3.6667,3.9167,4.1667,4.4167,4.6667},3,
	4,repeats,y)
end

function thisisthestoryofagirl(beat,repeats,y)
	baselyricsfunc(beat,0,
	'This/ is/ the/ sto/ry/ of/ a/ girl.',
	{0.3333, 1.25, 1.5,1.75,2,2.25,2.5},2,
	4,repeats,y)
end

function thisis(beat,repeats,y)
	baselyricsfunc(beat,0,
	'This/ is',
	{0.3333},2,
	8,repeats,y)
end

function itsbeenoneweek(beat,repeats,y)
	baselyricsfunc(beat,2,
	"It's/ been/ one/ week/ since/ you've/ looked/ at/ me.",
	{0.75,1.75,2.25,2.75,3,3.25,3.58333,4},2,
	8,repeats,y)
end

function itsbeen(beat,repeats,y)
	baselyricsfunc(beat,2,
	"It's/ been",
	{0.75},2,
	8,repeats,y)
end

function somebodyoncetoldme(beat,repeats,y)
	baselyricsfunc(beat,7,
	"Some/bo/dy/ once/ told/ me",
	{1,1.5,2,3,3.5},2,
	8,repeats,y)
end
function some(beat,repeats,y)
	baselyricsfunc(beat,7,
	"Some",
	{},2,
	16,repeats,y)
end

function theworldisavampire(beat,repeats,y)
	baselyricsfunc(beat,9,
	"The/ world/ is/ a/ vam/pire.",
	{0.5,1.5,2,2.5,3.5},2,
	8,repeats,y)
end

function theworldisa(beat,repeats,y)
	baselyricsfunc(beat,9,
	"The/ world/ is/ a",
	{0.5,1.5,2},2,
	8,repeats,y)
end


function ivegotanotherconfession(beat,repeats,y)
	baselyricsfunc(beat,5,
	"I've/ got/ a/no/ther/ con/fess/ion/ to/ make.",
	{0.5,1,1.5,2,2.5,3,4,4.5,5},2,
	8,repeats,y)
end

function thisishowwedoit_swung(beat,repeats,y)
	baselyricsfunc(beat,1,
	"This/ is/ how/ we/ do/ it!",
	{0.75,1,1.75,2,3},2,
	4,repeats,y)
end

function swingrhythm(beat,repeats,y)
	baselyricsfunc(beat,1,
	"",
	{},0,
	4,repeats,y)
end

function thisishowwedoit(beat,repeats,y)
	baselyricsfunc(beat,3,
	"This/ is/ how/ we/ do/ it!",
	{0.5,1,1.5,2,2.5},2,
	8,repeats,y)
end
function scatting(beat)
	justlyrics(beat,1,
	"Sha/-la/-la/-la/-la/-la/-low!",
	{0.25,0.5,0.75,1.3333,2,2.5},2
	)
	justlyrics(beat+8,1,
	"Sha/-la/-la/-la/-la/-lo/-woah!",
	{0.25,0.5,0.75,1.3333,2,2.5},3
	)
	justlyrics(beat+16,1,
	"La/-la/-low/-la/-la/-lo/-ow!",
	{0.5,1.3333,2,2.66667,3,4},2
	)

end

function canttouchthis(beat,repeats,y)
	baselyricsfunc(beat,10,
	"Can't/ touch/ this.",
	{0.5,1},2,
	16,repeats,y)
end

function reluctantlycrouched(beat,repeats,y)
	baselyricsfunc(beat,4,
	"Re/luc/tant/ly/ crouched/ at/ the/ star/ting/ line.",
	{0.25,0.5,0.75,1,1.75,2,2.25,2.5,2.75},2,
	16,repeats,y)
end

function unodos(beat,repeats,y)
	baselyricsfunc(beat,8,
	"U/no!/ Dos!/ One/, Two/, Tres/, Qua/tro!",
	{0.25,2,4,5,6,7,7.5},2,
	16,repeats,y)
end

function weknowwhereweregoing(beat,repeats,y)
	baselyricsfunc(beat,6,
	"We/ know/ where/ we're/ go/in'",
	{0.5,2.5,3,4,5},3,
	8,repeats,y)
end

function knowwhereweregoing(beat,repeats,y)
	baselyricsfunc(beat,6,
	"Know/ where/ we're/ go/in'",
	{2,2.5,3.5,4.5},3,
	8,repeats,y)
end

function onetwothree(beat,repeats,y)
	baselyricsfunc(beat,10,
	"One!/ Two!/ Three!/ Uh!",
	{1,2,3},2,
	16,repeats,y)
end

function everybodydancenow(beat,repeats,y)
	baselyricsfunc(beat,1,
	"Eve/ry/bo/dy/ dance/ now!",
	{0.5,1,1.5,2,3},2,
	4,repeats,y)
end
thisisthestoryofagirl_first(0.333)

thisisthestoryofagirl(6.5,22)
itsbeenoneweek(18.75,10)
somebodyoncetoldme(39,7)
theworldisavampire(51.5,6)
ivegotanotherconfession(64.5,4)
some(95)

hiderows(96,{0,2,7,9,5})
thisishowwedoit_swung(96)

swingrhythm(100,7)
thisishowwedoit(104,3)
scatting(107)

thisishowwedoit_swung(128)
canttouchthis(130.5)
reluctantlycrouched(131.75,2)

swingrhythm(132,8)
thisishowwedoit(136,4)
scatting(139)

somebodyoncetoldme(135)
unodos(140,2)
thisisthestoryofagirl(150.5,3)

swingrhythm(164,8)
weknowwhereweregoing(163.5,2)
thisis(166.5,4)
theworldisavampire(167.5,3)
itsbeen(170.75)
some(179,2)
knowwhereweregoing(180)
canttouchthis(186.5)
weknowwhereweregoing(187.5)
theworldisa(191.5)

swingrhythm(196,7)
thisisthestoryofagirl(198.5,6)
somebodyoncetoldme(199)
ivegotanotherconfession(200.5,3)
itsbeenoneweek(202.75,3)
onetwothree(208,2)
somebodyoncetoldme(215)
thisis(222.5,5)
everybodydancenow(224)


reluctantlycrouched(227.75,2)
knowwhereweregoing(228,4)
swingrhythm(228,7)
theworldisavampire(231.5,3)
canttouchthis(234.5,2)
unodos(236,2)
some(243)
theworldisa(255.5)
thisishowwedoit_swung(256)


swingrhythm(260,7)
thisisthestoryofagirl(262.5,7)
thisishowwedoit(264,3)
itsbeenoneweek(266.75,3)

level.rows[7]:move(290.5,{x=600},1,'Linear')

level.rooms[1]:floatingtext(291,'SOME',{},50,75,64,nil,nil,nil,nil,nil,nil,1)

movequeue.execute()