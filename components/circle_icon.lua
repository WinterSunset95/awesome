local gears = require("gears")
local awful = require("awful")
local wibox = require("wibox")
local naughty = require("naughty")
local beautiful = require("beautiful")
local animate = require("helpers.animate")

local function create_icon(path, id)
	local icon = wibox.widget({
		{
			image = path,
			resize = false,
			widget = wibox.widget.imagebox,
		},
		widget = wibox.container.background,
		shape_clip = true,
		bg = beautiful.bg_focus,
		shape = gears.shape.circle,
	})
	return icon
end

return create_icon
