local dpf = {}


function dpf.loadjson(f,w,force)
  w = w or {}
  print("dpf loading " .. f)
  local cf = io.open(f, "r+")
  if cf == nil then
    if force then
      error('DPF: could not load file ' .. f)
    end
    
    cf = io.open(f, "w")
    cf:write(json.encode(w))
    cf:close()
    cf = io.open(f, "r+")
  end
  local text = cf:read("*a")
  if string.sub(f,-8) == ".rdlevel" then
    text = text:sub(4) -- BEGONE, ∩╗┐
  end
  local filejson = json.decode(text)
  cf:close()
  return filejson
end
function dpf.loadtracery(f)
  print("dpf loading tracery " .. f)
  local cf = io.open(f, "r+")
  local filejson = json.decode(cf:read("*a"))
  cf:close()
  local grammar = tracery.createGrammar(filejson)
  grammar:addModifiers(tracery.baseEngModifiers)
  return grammar
end

function dpf.savejson(f,w)
  local cf = io.open(f, "w")
  cf:write(json.encode(w))
  cf:close()
end

function dpf.saverdlevel(f,w)
  local cf = io.open(f, "w")
  local str = json.encode(w)
  str = string.gsub(str,'"_DN_NULL"','null')
  cf:write(str)
  cf:close()
end

return dpf