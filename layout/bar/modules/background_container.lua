local gears = require("gears")
local awful = require("awful")
local wibox = require("wibox")
local naughty = require("naughty")
local beautiful = require("beautiful")

local function build(widget, margin, id)
	local container = wibox.widget({
		{
			widget,
			widget = wibox.container.margin,
			margins = margin,
		},
		id = id,
		widget = wibox.container.background,
		bg = beautiful.bg_focus,
		shape = gears.shape.rounded_rect,
	})
	return container
end

return build
