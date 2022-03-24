-- swift mecha


level:setuprooms()



for i=2,10,2 do
	level:rdcode(0,'SetShadowRow('..i..', 0)','OnPrebar')
	level:rdcode(0,'SetShadowRow('..(i+1)..', 1)','OnPrebar')
end


__fov = 100

function distance(x,y,a,b)
  return(math.sqrt(((a)-(x))^2+((b)-(y))^2))
end

function anglepoints(x,y,a,b)
  return math.deg(math.atan2(x-a,y-b))*-1-90
end

function project(p,r,s)
	
	local cosx = math.cos(r.x*(math.pi/180))
	local sinx = math.sin(r.x*(math.pi/180))
	
	local cosy = math.cos(r.y*(math.pi/180))
	local siny = math.sin(r.y*(math.pi/180))
	
	local cosz = math.cos(r.z*(math.pi/180))
	local sinz = math.sin(r.z*(math.pi/180))
	
	local xx = cosx * cosy
	local xy = cosx * siny * sinz - sinx * cosz
	local xz = cosx * siny * cosz + sinx * sinz
	
	local yx = sinx * cosy
	local yy = sinx * siny * sinz + cosx * cosz
	local yz = sinx * siny * cosz - cosx * sinz
	
	local zx = 0 - siny
	local zy = cosy * sinz
	local zz = cosy * cosz
	
	local px = xx*p.x + xy*p.y + xz*p.z
	local py = yx*p.x + yy*p.y + yz*p.z
	local pz = zx*p.x + zy*p.y + zz*p.z
	
	px = px * s.x * s.g
	py = py * s.y * s.g
	pz = pz * s.z * s.g
	
	
	p.px = px * (1+ (pz / __fov))
	p.py = py * (1+ (pz / __fov))
	
	
end

r = {x=0,y=0,z=0}
scale = {x=(9/16),y=1,z=1,g=30}

points = {
	{x=1,y=1,z=1},
	{x=-1,y=1,z=1},
	{x=1,y=-1,z=1},
	{x=-1,y=-1,z=1},

	{x=1,y=1,z=-1},
	{x=-1,y=1,z=-1},
	{x=1,y=-1,z=-1},
	{x=-1,y=-1,z=-1},
}
rowlines = {
	{1,2},
	{2,4},
	{4,3},
	{3,1},
	
	{1,5},
	{6,2},
	{3,7},
	{8,4},
	
	{5,6},
	{6,8},
	{8,7},
	{7,5}
}


-- "type": "MoveRow", "row": 0, "target": "WholeRow", "customPosition": true, "rowPosition": [50, 50], "scale": [1, 1], "angle": 0, "pivot": 0, "duration": 1, "ease": "Linear" },
framesperbeat = 2
lastangle = {0,0,0,0,0,0,0,0,0,0,0,0}
for beat = 64,128,1/framesperbeat do
	r.x = r.x + 12/framesperbeat
	r.y = r.y + 12/framesperbeat
	r.z = r.z + 12/framesperbeat
	
	for pi,pv in ipairs(points) do
		project(pv,r,scale)
	end
	
	for ri = 0,11 do
		local x1 = points[rowlines[ri+1][1]].px + 50
		local y1 = points[rowlines[ri+1][1]].py + 50
		local x2 = points[rowlines[ri+1][2]].px + 50
		local y2 = points[rowlines[ri+1][2]].py + 50
		local angle = anglepoints(x1*(16/9),y1,x2*(16/9),y2) % 360
		local scale = distance(x1*(16/9),y1,x2*(16/9),y2) * 0.007
		
		local lastbase = math.floor((lastangle[ri+1]/360)+0.5)

		local min_distance = (((lastbase)*360+angle) - lastangle[ri+1]+180)%360-180
		angle = lastangle[ri+1] + min_distance
		
		local instant = 1
		if math.abs(min_distance) >= 90 or  beat == 64 then
			--instant = 0
		end
		if ri == 0 then
			print(lastangle[1],min_distance)
		end
		
		
		level:addevent(beat,'MoveRow',{
			row = ri,
			target= 'WholeRow',
			customPosition = true,
			rowPosition = {x1,y1},
			scale = {scale,scale},
			pivot = 0,
			angle = angle,
			duration = (1/framesperbeat)*instant,
			ease = 'Linear'
		})
		lastangle[ri+1] = angle
			
	end
end