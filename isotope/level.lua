-- isotope

level:clearevents({
  'SetBackgroundColor',
  'TintRows'
})

level:setuprooms()
level:hideallatstart()



--set up rooms
ontop = level.rooms[4]

level:reorderrooms(0,2,0,1,3)

r = level.rooms


-- set up rows
red = {}
oneshot = {}
bf = {}

red[0] = level.rows[0]
oneshot[0] = level.rows[1]
bf[0] = level.rows[2]

red[1] = level.rows[3]
oneshot[1] = level.rows[4]
bf[1] = level.rows[5]


function doubled(func) --for pretty much all of the level, rooms 0 and 1 should be identical.
	for i=0,1 do
		func(r[i],red[i],oneshot[i],bf[i])
	end
end

level:alloutline()

doubled(function(r,red,oneshot,bf)
	red:show(0,2)
	bf:showchar(0)
	red:move(0,{x=85,y=32,sx=-1,pivot=0})
	bf:move(0,{x=15,y=14,pivot=0})
end)




--intro

r[2]:fade(0,0)
r[2]:jpeg(0,true,100)

ontop:flash(0,'000000',100,nil,0,2,'linear')

r[0]:lightstripvert(0,true)

doubled(function(r,red,oneshot,bf) 
	r:setbg(0,'bg_temp.png')
	
	r:jpeg(0,true,10)
end)



r[0]:fade(30,0,2,'linear')
r[0]:lightstripvert(32,false)
r[0]:fade(34,100,0,'linear')

doubled(function(r,red,oneshot,bf) 
	r:pulsecamera(32,7,4,0)

	bf:show(58,2)
	r:jpeg(58,true,30,4,'outExpo')
	r:cam(58,{x=72,y=36,zoom=200},4,'outSine')
end)

r[2]:vignette(58)
r[2]:fade(58,100,2,'linear')

doubled(function(r,red,oneshot,bf) 
	r:jpeg(64,true,10,4,'outExpo')
	r:cam(64,{x=50,y=50,zoom=100},2,'outSine')
end)

r[2]:fade(64,0,4,'outExpo')
