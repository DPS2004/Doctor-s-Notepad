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
