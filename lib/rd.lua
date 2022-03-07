local rd = {}

function rd.load(filename)
  local level = {}
  level.data = dpf.loadjson(filename,{},true)
  
  -- save level to file
  function level:save(filename)
    dpf.savejson(filename,self.data)
  end
  
  -- clear or keep every event that has the same type as any event in eventtypes
  function level:clearevents(eventtypes,keeplisted)
    keeplisted = keeplisted or false
    local newevents = {}
    for eventi,event in ipairs(self.data.events) do
      local listedfound = false
      for typei,typev in ipairs(eventtypes) do
        if event.type == typev then
          listedfound = true
        end
      end
      if listedfound == keeplisted then
        table.insert(newevents,event)
      end
    end
    self.data.events = newevents
  end
  
  -- shorthand for level:clearevents(eventtypes, true)
  function level:keepevents(eventtypes)
    self:clearevents(eventtypes, true)
  end
  
  -- convert beatnumber (0 indexed) to bar measure pair (1 indexed)
  function level:getbm(inbeat)
    local crotchet = 8
    local bar = 1
    local beat = 1
    local cbeat = 0
    
    local remainder = inbeat - math.floor(inbeat)
    inbeat = math.floor(inbeat)
    
    local crotchetevents = {}
    
    for eventi,event in ipairs(self.data.events) do
      if event.type == 'SetCrotchetsPerBar' then
        table.insert(crotchetevents,event)
      end
    end
    
    while true do
      if cbeat == inbeat then
        break
      end
      
      for eventi,event in ipairs(crotchetevents) do
        if event.bar == bar and event.beat == beat then
          crotchet = event.crotchetsPerBar
        end
      end
      
      beat = beat + 1
      if beat > crotchet then
        bar = bar + 1
        beat = 1
      end
      
      cbeat = cbeat + 1
    end
    return bar, beat + remainder
    
  end
  
  return level
end



return rd