local awful = require("awful")
local mod = require("bindings.mod")
local wibox = require("wibox")
local beautiful = require("beautiful")
local gears = require("gears")

local tray = wibox.widget.systray()
tray:set_horizontal(false)
tray:set_base_size(20)

local systray = {
	{
		tray,
		margins = 5,
		widget = wibox.container.margin,
	},
	widget = wibox.container.background,
	bg = beautiful.bg_focus,
	shape = gears.shape.rounded_rect,
}

return systray
