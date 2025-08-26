local wibox = require("wibox")
local gears = require("gears")

local function create_separator(height)
	local separator = wibox.widget({
		widget = wibox.widget.separator,
		shape = gears.shape.rounded_bar,
		thickness = 2,
		forced_height = height,
		opacity = 0,
	})
	return separator
end

return create_separator
