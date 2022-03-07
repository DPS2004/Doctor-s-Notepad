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
level.rows[2]:setvisibleatstart(false)
level.rows[3]:setvisibleatstart(false)
level.rows[4]:setvisibleatstart(false)
level.rows[5]:setvisibleatstart(false)
level.rows[6]:setvisibleatstart(false)

-- room 0
mainroom = level.rooms[0]
mainroom:settheme(0,'Space')
mainroom:move(0,{x=100,y=50,sx=0,sy=100})

-- room 1
introroom = level.rooms[1]
introroom:settheme(0,'InsomniacDay')
introroom:sepia(0)
introroom:vhs(0)

introroom:move(0,{x=50,y=50,sx=100,sy=100})

level.rows[1]:setroom(0,1)

level:alloutline() -- give every row black outlines

-- at beat 9, change rooms
introroom:move(9,{x=0,y=50,sx=0,sy=100},2,'outExpo')
mainroom:move(9,{x=50,y=50,sx=100,sy=100},2,'outExpo')

