local gears = require("gears")
local awful = require("awful")
local wibox = require("wibox")
local naughty = require("naughty")
local beautiful = require("beautiful")
local log = require("helpers.debugger").log

local text_font = "Cousine Nerd Font Mono Black"

local function create_slider()
	local displayer = wibox.widget({
		widget = wibox.widget.progressbar,
		color = beautiful.fg_focus,
		background_color = beautiful.fg_normal,
		bar_shape = gears.shape.rectangle,
		shape = gears.shape.rounded_rect,
		clip = true,
		max_value = 100,
		min_value = 0,
		value = 40,
		id = "role_display",
	})
	local text = wibox.widget({
		text = "󰕾",
		font = text_font .. " 30",
		widget = wibox.widget.textbox,
	})
	local controller = wibox.widget({
		bar_shape = gears.shape.rounded_rect,
		bar_height = DPI(60),
		bar_color = "#00000000",
		handle_width = DPI(10),
		handle_color = "#00000000",
		handle_border_color = "#00000000",
		handle_border_width = DPI(0),
		widget = wibox.widget.slider,
		minimum = 0,
		maximum = 100,
		value = 40,
	})

	local slider = wibox.widget({
		displayer,
		{
			{
				text,
				fg = beautiful.bg_normal,
				widget = wibox.container.background,
				bg = "#00000000",
			},
			widget = wibox.container.margin,
			left = DPI(20),
		},
		controller,
		layout = wibox.layout.stack,
		forced_height = DPI(60),
	})
	return {
		slider = slider,
		displayer = displayer,
		text = text,
		controller = controller,
	}
end

return create_slider
