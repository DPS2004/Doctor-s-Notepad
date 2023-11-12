-- Doctor's Notepad
-- A project by DPS2004

--extensions to load

-- As default-config.lua now exists, this is not needed here anymore -- keeping it commented out instead of removing it for now
--[[
extensions = {
	'core',
	'row',
	'room',
    'decoration',
	'color', 
    'sound',
    'classybeat',
    'conditional'
}
]]

-- helpful functions

function tget(t, f)
    for i, v in ipairs(t) do
        if f(v) then
            return v
        end
    end
end

function tset(t, f, val)
    for i, v in ipairs(t) do
        if f(v) then
            v = val
        end
    end
end

function setvalue(self, vname, beat, state)
	beat = beat + level.eos
    self.values[vname] = self.values[vname] or {}
    for i, v in ipairs(self.values[vname]) do
        if v.beat == beat then
            table.remove(self.values[vname], i)
        end
    end
    table.insert(self.values[vname], {beat = beat, state = state})
end

null = "_DN_NULL"

function getvalue(self, vname, beat)
	beat = beat + level.eos
    local matchbeat = 0
    local matchval = nil
    for i, v in ipairs(self.values[vname]) do
        if v.beat >= matchbeat and v.beat <= beat then
            matchbeat = v.beat
            matchval = v.state
        end
    end
    return matchval
end

function quoteifstring(v)
    if type(v) == 'string' then return ('"' .. tostring(v) .. '"')
    else return tostring(v)
    end
end

local defaultstacklevel = 3
checkvar_override = false

-- utility error methods
function checkvar_throw(text, stackLevel)
    error(text, stackLevel or defaultstacklevel)
end

-- method that checks if a variable is a certain type
-- n is the original variable name, a string
function checkvar_type(v, n, t, nilAccepted, stackLevel)
    if checkvar_override then return end
    if v == nil and nilAccepted then return end
    local vt = type(v)
    if vt ~= t then
        checkvar_throw('invalid type exception: ' .. n .. ' is a ' .. vt .. ' but it should be a ' .. t, stackLevel)
    end
end

shown_ease_warning = false

function checkvar_enum(v, n, enum, nilAccepted)
    if checkvar_override then return end
    if v == nil and nilAccepted then return end
	
	if enum == enums.ease then
		if enums.ease_lower[v] then
			if not shown_ease_warning then
				print('WARNING: camelCase for eases may not be supported for all events.')
				shown_ease_warning = true
			end
			return
		end
	end
	
    if not enum[v] then
        checkvar_throw('invalid type exception: ' .. n .. ' is ' .. quoteifstring(v) .. ' but must be one of ' .. enum.__stringformat, 4)
    end
end

function checkvar_color(c, n, nilAccepted, stackLevel)
    if checkvar_override then return end
    if c == nil and nilAccepted then return end
    checkvar_type(c, n, 'string', false, stackLevel)

    if not c:match('^#?%x%x%x%x%x%x$') and not c:match('^#?%x%x%x%x%x%x%x%x$') then
        checkvar_throw(n .. ' not in valid hexadecimal format: ' .. c, stackLevel)
    end
end

local function isspecialrdcodevar(v)
    return v:match('^[ifb]%d+$')
end

function checkvar_rdcodevar(c, n, t, nilAccepted, stackLevel)
    if checkvar_override then return end
    if c == nil and nilAccepted then return end
    checkvar_type(c, n, 'string', false, stackLevel)

    local ch = c:sub(1,1)
    if isspecialrdcodevar(c) then
        if #c - 1 > 1 then
            checkvar_throw('the variable ' .. n .. ' (' .. c .. ') does not exist - only up to ' .. ch .. '9 is accepted', stackLevel)
        end

        if (ch == 'i' and t ~= 'integer')
            or (ch == 'f' and t ~= 'float')
            or (ch == 'b' and t ~= 'boolean') then
            checkvar_throw('the variable ' .. n .. ' (' .. c .. ') is not a ' .. t, stackLevel)
        end
    end
end

function checkvar_room(r, n, t, nilAccepted, stackLevel)
    if checkvar_override then return end
    if c == nil and nilAccepted then return end
    checkvar_type(r, n, 'number', false, stackLevel)

    if r < 0 or r > 3 then
        checkvar_throw('the room ' .. r .. ' does not exist!', stackLevel)
    end
end

function checkvar_typewithrdcode(v, n, t, ct, nilAccepted, stackLevel)
    if checkvar_override then return end
    if type(v) == 'string' and v:match('^{.+}$') then
        checkvar_rdcodevar(v:sub(2, -2), n, ct, nilAccepted, (stackLevel or defaultstacklevel) + 1)
        return
    end
    checkvar_type(v, n, t, nilAccepted, (stackLevel or defaultstacklevel) + 1)
end

function disable_checkvar()
    if checkvar_override then return end
    print('Parameter safety checks disabled!')
    checkvar_override = true
end

enums = {}

function create_enum(name, list)
    local new_enum = {}
    local builder = {}

    for i, v in ipairs(list) do
        new_enum[v] = i
        builder[i] = quoteifstring(v)
    end

    new_enum.__stringformat = table.concat(builder, ', ')
    enums[name] = new_enum
    return new_enum
end

create_enum('ease', {
    'Linear',
    'InSine', 'OutSine', 'InOutSine',
    'InQuad', 'OutQuad', 'InOutQuad', 
    'InCubic', 'OutCubic', 'InOutCubic',
    'InQuart', 'OutQuart', 'InOutQuart',
    'InQuint', 'OutQuint', 'InOutQuint',
    'InExpo', 'OutExpo', 'InOutExpo',
    'InCirc', 'OutCirc', 'InOutCirc',
    'InElastic', 'OutElastic', 'InOutElastic',
    'InBack', 'OutBack', 'InOutBack',
    'InBounce', 'OutBounce', 'InOutBounce'
})

create_enum('ease_lower', {
    'linear',
    'inSine', 'outSine', 'inOutSine',
    'inQuad', 'outQuad', 'inOutQuad', 
    'inCubic', 'outCubic', 'inOutCubic',
    'inQuart', 'outQuart', 'inOutQuart',
    'inQuint', 'outQuint', 'inOutQuint',
    'inExpo', 'outExpo', 'inOutExpo',
    'inCirc', 'outCirc', 'inOutCirc',
    'inElastic', 'outElastic', 'inOutElastic',
    'inBack', 'outBack', 'inOutBack',
    'inBounce', 'outBounce', 'inOutBounce'
})

-- Load Libraries
json = require "lib/json" -- json parser

dpf = require "lib/dpf" -- functions for handling json files

logger = require "lib/log" -- logging

deeper = require "lib/deeper"

log = logger.log

rd = require "lib/rd" -- main doctor's notepad library

log("Doctor's Notepad")

inlevel = arg[1]

if not inlevel then
    error("Usage: main.lua [level folder]")
end

level = rd.load(inlevel .. "/level.rdlevel")
level:init()
script = assert(loadfile(inlevel .. "/level.lua"))

script()

level:save(inlevel .. "/out.rdlevel")
