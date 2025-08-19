local gears = require("gears")
local awful = require("awful")
local wibox = require("wibox")
local naughty = require("naughty")
local beautiful = require("beautiful")
local mytaglist = require("layout.bar.modules.taglist")

local mytextclock = require("layout.bar.modules.clock")
local systray = require("layout.bar.modules.systray")
local battery = require("layout.bar.modules.battery")

local mod = require("bindings.mod")

local icon_font = "Cousine Nerd Font Mono Black 30"

local side_menu = wibox.widget({
	homogenous = true,
	spacing = 5,
	min_cols_size = 10,
	min_rows_size = 10,
	layout = wibox.layout.grid,
})

awful.screen.connect_for_each_screen(function(s)
	-- Create a taglist widget
	s.mytaglist = mytaglist

	-- Create the wibox
	s.mywibox = awful.wibar({
		position = "left",
		screen = s,
		width = 60,
	})
	-- Add widgets to the wibox
	s.mywibox:setup({
		layout = wibox.layout.margin,
		margins = 10,
		{
			layout = wibox.layout.align.vertical,
			{
				{
					{
						font = icon_font,
						text = "󱗼",
						align = "center",
						widget = wibox.widget.textbox,
					},
					widget = wibox.container.background,
					bg = beautiful.bg_focus,
					shape = gears.shape.rounded_rect,
					buttons = gears.table.join(awful.button({}, 1, function()
						naughty.notify({ text = "hello" })
					end)),
				},
				mytextclock,
				layout = wibox.layout.fixed.vertical,
				spacing = 5,
			},
			{
				{
					{
						{
							s.mytaglist,
							widget = wibox.container.margin,
							margins = 5,
						},
						widget = wibox.container.background,
						shape = gears.shape.rounded_rect,
						bg = beautiful.bg_focus,
					},
					widget = wibox.layout.fixed.vertical,
					spacing = 5,
				},
				widget = wibox.container.place,
			},
			{
				battery,
				widget = wibox.layout.align.vertical,
			},
		},
	})
end)
