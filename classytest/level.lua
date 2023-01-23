level:setuprooms()

mycoolrow = level:getrow(0)
mycoolrow2 = level:getrow(1)

mycoolrow:classyinit()
mycoolrow2:classyinit()

mycoolrow:showclassy(0)
mycoolrow2:showclassy(0)

mycoolrow:movey(0, 67, 0, 'Linear')
mycoolrow2:movey(0, 33, 0, 'Linear')

mycoolrow:classyusepivot(1, true)
mycoolrow:rotate(1, 20, 2, 'OutSine')
mycoolrow:rotate(3, -20, 4, 'InOutSine')
mycoolrow:rotate(7, 20, 4, 'InOutSine')
mycoolrow:rotate(11, -20, 4, 'InOutSine')

mycoolrow2:delayclassy(1, 0.25)
mycoolrow2:movey(1, 40, 1, 'OutQuad')
mycoolrow2:movey(2, 26, 2, 'InOutQuad')
mycoolrow2:movey(4, 40, 2, 'InOutQuad')

mycoolrow2:delayclassy(8, -0.25)
mycoolrow2:movey(8, 26, 2, 'InOutQuad')
mycoolrow2:movey(10, 40, 2, 'InOutQuad')
mycoolrow2:movey(12, 26, 2, 'InOutQuad')
mycoolrow2:movey(14, 40, 2, 'InOutQuad')