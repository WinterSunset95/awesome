local gears = require("gears")
local awful = require("awful")
local wibox = require("wibox")
local naughty = require("naughty")
local beautiful = require("beautiful")

local set_font = "Cousine Nerd Font Mono Black"

local function create_icon(glyph, name, signal)
	local icon = wibox.widget({
		{
			{
				{
					font = set_font .. " 30",
					text = glyph,
					widget = wibox.widget.textbox,
					align = "center",
				},
				widget = wibox.container.background,
				shape = gears.shape.circle,
				forced_width = 70,
				forced_height = 70,
				bg = beautiful.fg_normal,
				fg = beautiful.fg_focus,
				id = "role_button",
				buttons = gears.table.join(awful.button({}, 1, function()
					awesome.emit_signal(signal)
				end)),
			},
			{
				font = set_font .. " 10",
				text = name,
				align = "center",
				widget = wibox.widget.textbox,
			},
			widget = wibox.layout.fixed.vertical,
			spacing = 5,
		},
		widget = wibox.container.place,
	})

	return icon
end

return create_icon
