local config = {}

local defaultConfig = loadfile('default-config.lua')
local defaultConfigEnv = {}

local levelConfig
local levelConfigEnv = {}

local function setConfigEnvAndRun(config, env)
	if not config then return nil, true end

	setfenv(config, env)
	local res, err = pcall(config)
	return res, err
end

function config.getDefaultConfig()
	local res, err = setConfigEnvAndRun(defaultConfig, defaultConfigEnv)
	if err then
		error('Default config file "default-config.lua" not found')
	end
end

function config.prepareLevelConfig(levelDir)
	local configPath = levelDir .. '/config.lua'

	levelConfig = loadfile(configPath)
	local res, err = setConfigEnvAndRun(levelConfig, levelConfigEnv)

	if err then
		print('Could not find level-specific config for ' .. levelDir)
		return
	end

	-- assume any config values found in 'default-config.lua' are the right type, and compare level config values' types with them
	for k, v in pairs(levelConfigEnv) do
		local defaultConfigValue = defaultConfigEnv[k]

		-- config value not present in 'default-config.lua', produce warning
		if not defaultConfigValue then
			print('Config key "' .. k .. '" unused')
		end

		-- config value is of wrong type, error
		if defaultConfigValue and type(defaultConfigValue) ~= type(v) then
			error('Config key "' .. k .. '" is ' .. type(v) .. ' but must be ' .. type(defaultConfigValue))
		end

	end

end

function config.getConfigValue(key)
	if levelConfigEnv[key] ~= nil then
		return levelConfigEnv[key]
	else
		return defaultConfigEnv[key]
	end
end

config.getDefaultConfig()

return config