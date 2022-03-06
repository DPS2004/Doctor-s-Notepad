-- Doctor's Notepad
-- A project by DPS2004



-- Load Libraries
json = require 'lib/json'  -- json parser

dpf = require 'lib/dpf'    -- functions for handling json files

logger = require 'lib/log' -- logging
log = logger.log

rd = require 'lib/rd'      -- main doctor's notepad library  

log('Doctor\'s Notepad')



inlevel = arg[1]

if not inlevel then
  error('Usage: main.lua [level folder]')
end

level = rd.load(inlevel .. '/level.rdlevel')
script = assert(loadfile(inlevel .. '/level.lua'))

script()

level:save(inlevel .. '/out.rdlevel')