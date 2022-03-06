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
  
  return level
end



return rd