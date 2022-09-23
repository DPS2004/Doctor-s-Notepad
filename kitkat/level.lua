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
level:hideallatstart()

-- room 0
mainroom = level.rooms[0]
mainroom:move(0,{x=100,y=50,sx=0,sy=100})

-- room 1
introroom = level.rooms[1]

--just to make it play a bit nicer with HOM
level:ccode(0,"shockwave(size,0)")

--intro
level:alloutline() -- give every row black outlines

introroom:move(0,{x=50,y=50,sx=100,sy=100})
introroom:settheme(0,'InsomniacDay')
introroom:sepia(0)
introroom:vhs(0)
introroom:aberration(0,true,25)
level.rows[1]:setroom(0,1)
level.rows[1]:show(0)


-- at beat 9, change rooms
introroom:move(9,{x=0,y=50,sx=0,sy=100},2,'outExpo')
mainroom:move(9,{x=50,y=50,sx=100,sy=100},2,'outExpo')
mainroom:hom(9)

level.rows[0]:show(0)

