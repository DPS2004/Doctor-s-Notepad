level:setuprooms()

mycoolrow = level:getrow(0)
mycoolrow2 = level:getrow(1)

mycoolrow:classyinit()
mycoolrow2:classyinit()

mycoolrow:showclassy(0)
mycoolrow2:showclassy(0)

mycoolrow:delayclassy(0, 0.125)
mycoolrow2:delayclassy(0, -0.5)

mycoolrow:move(2, {
	y = 75
}, 2, 'OutExpo')

mycoolrow:move(2.5, {
	y = 50
}, 2, 'InExpo')

mycoolrow2:move(6, {
	y = 25
}, 2, 'InOutQuad')

mycoolrow2:move(10, {
	y = 50
}, 4, 'InOutElastic')