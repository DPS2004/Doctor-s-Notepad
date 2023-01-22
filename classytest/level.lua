level:setuprooms()

mycoolrow = level:getrow(0)
mycoolrow2 = level:getrow(1)

mycoolrow:classyinit()
mycoolrow2:classyinit()

mycoolrow:showclassy(0)
mycoolrow2:showclassy(0)

mycoolrow:move(2, {
	y = 75
}, 2, 'OutSine')