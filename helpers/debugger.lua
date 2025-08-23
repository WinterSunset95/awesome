local gears = require("gears")
local naughty = require("naughty")
local serialize = require("helpers.serialize")

local function log(message)
	local stringified = gears.debug.dump_return(message)
	-- print to a file
	local filepath = os.getenv("HOME") .. "/.cache/awesome.log"
	local file = io.open(filepath, "a")
	if not file then
		file = io.open(filepath, "w")
		if not file then
			naughty.notify({
				preset = naughty.config.presets.critical,
				title = "Could not open log file",
				text = filepath,
			})
			return
		end
	end

	file:write(stringified .. "\n")
	file:close()
end

local function print(message)
	local stringified = serialize(message)
	-- print to a file
	local filepath = os.getenv("HOME") .. "/.cache/awesome.log"
	local file = io.open(filepath, "a")
	if not file then
		file = io.open(filepath, "w")
		if not file then
			naughty.notify({
				preset = naughty.config.presets.critical,
				title = "Could not open log file",
				text = filepath,
			})
			return
		end
	end

	file:write(stringified .. "\n")
	file:close()
end

return {
	log = log,
	print = print,
}
