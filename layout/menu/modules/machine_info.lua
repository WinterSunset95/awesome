local gears = require("gears")
local awful = require("awful")
local wibox = require("wibox")
local naughty = require("naughty")
local beautiful = require("beautiful")

local user = require("user")
local imageicon = require("components.circle_icon")
local icon = imageicon(user.user_img, "machine_info")

local icon_font = "Cousine Nerd Font Mono Black 12"

local machine_info = wibox.widget({
	{
		{
			{
				font = icon_font,
				text = "󰣇: " .. user.host,
				widget = wibox.widget.textbox,
			},
			{
				font = icon_font,
				text = ": Awesome WM",
				widget = wibox.widget.textbox,
			},
			{
				font = icon_font,
				text = ": " .. os.date("%H:%M"),
				widget = wibox.widget.textbox,
			},
			widget = wibox.container.place,
			layout = wibox.layout.flex.vertical,
		},
		widget = wibox.container.margin,
		margins = 10,
		forced_height = 100,
	},
	widget = wibox.container.background,
	shape = gears.shape.rounded_rect,
	bg = beautiful.bg_focus,
	forced_height = 100,
})

return machine_info
