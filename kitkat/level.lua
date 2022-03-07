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


for i=0,40 do
print(i)
print(level:getbm(i))
end