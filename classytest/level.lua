level:setuprooms()

mycoolrow = level:getrow(0)

level:getrow(1):hide(1)

mycoolrow:classyinit()

mycoolrow:showclassy(0)

mycoolrow:move(2, {
	y = 75
}, 2, 'OutSine')

mycoolrow:movey(4, 25, 4, 'InOutSine')

--[[
mycoolrow:move(5, {
	sx = 1.5,
	sy = 1
}, 6, 'InOutBounce')
]]

-- mycoolrow:showchar(2)
-- mycoolrow:showrow(3)

-- mycoolrow:movex(5, 75, 4, 'Linear')
-- mycoolrow:movesx(6, 2, 1, 'OutElastic')
