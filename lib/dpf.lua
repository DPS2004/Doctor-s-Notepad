local dpf = {}

-- bit of a hack, but oh well
local DN_NULL = '"' .. null .. '"'

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

  local in_str = false
  local i = 1

  while i <= #text do
    if text:sub(i,i) == '"' and text:sub(i-1,i) ~= '\\"' then
      in_str = not in_str

    elseif text:sub(i,i+3) == 'null' and not in_str then
      text = text:sub(1,i-1) .. DN_NULL .. text:sub(i+4,-1)
      print(("Replaced the 'null' at %s with %s; surrounding: '%s'"):format(i, DN_NULL, text:sub(i-20, i+23)))
      i = i - 1
    end

    i = i + 1
  end

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
  str, replacements = string.gsub(str,DN_NULL,'null')
  cf:write(str)
  cf:close()
end

return dpf