local gears = require("gears")
local awful = require("awful")
local wibox = require("wibox")
local naughty = require("naughty")
local beautiful = require("beautiful")

local text_font = "Cousine Nerd Font Mono Black"

local function create_rounded_rect(signal)
	local rounded_rect = wibox.widget({
		{
			{
				{
					text = "󰖩",
					font = text_font .. " 50",
					widget = wibox.widget.textbox,
					align = "center",
					id = "role_logo",
				},
				{
					{
						{
							text = "Wi-Fi",
							font = text_font .. " 12",
							widget = wibox.widget.textbox,
							id = "role_name",
						},
						{
							text = "Off",
							font = text_font .. " 8",
							widget = wibox.widget.textbox,
							id = "role_id",
						},
						layout = wibox.layout.fixed.vertical,
						spacing = 5,
					},
					widget = wibox.container.place,
				},
				layout = wibox.layout.fixed.horizontal,
				spacing = 10,
			},
			id = "margin_container",
			widget = wibox.container.margin,
			margins = 10,
		},
		id = "role_container",
		widget = wibox.container.background,
		shape = gears.shape.rounded_rect,
		bg = beautiful.fg_focus,
		fg = beautiful.bg_normal,
		buttons = gears.table.join(
			awful.button({}, 1, function()
				awesome.emit_signal(signal .. "1")
			end),
			awful.button({}, 1, function()
				awesome.emit_signal(signal .. "2")
			end),
			awful.button({}, 3, function()
				awesome.emit_signal(signal .. "3")
			end),
			awful.button({}, 1, function()
				awesome.emit_signal(signal .. "4")
			end),
			awful.button({}, 1, function()
				awesome.emit_signal(signal .. "5")
			end)
		),
	})

	return rounded_rect
end

return create_rounded_rect
