local gears = require("gears")
local awful = require("awful")
local wibox = require("wibox")
local naughty = require("naughty")
local beautiful = require("beautiful")
local animate = require("helpers.animate")

local battery = require("layout.bar.modules.battery")
local machine_info = require("layout.menu.modules.machine_info")
local circle_icon = require("components.circle_icon")
local user = require("user")
local control_panel = require("layout.menu.modules.control_panel")
local menu_configs = require("config.menu")

local screen = awful.screen.focused()

local menu = wibox({
	screen = screen,
	visible = true,
	ontop = true,
	x = -menu_configs.menu_width,
	y = 0,
	height = menu_configs.menu_height,
	width = menu_configs.menu_width,
	widget = wibox.container.margin,
	margins = 10,
	bg = "#00000000",
})

local userinfo = wibox.widget({
	{
		{
			text = " Welcome " .. user.name .. "!",
			font = "Cousine Nerd Font Mono Black 16",
			widget = wibox.widget.textbox,
		},
		widget = wibox.container.margin,
		margins = 10,
	},
	shape = gears.shape.rounded_rect,
	widget = wibox.container.background,
	bg = beautiful.bg_focus,
})

menu:setup({
	{
		{
			userinfo,
			{
				{
					circle_icon(user.user_img, "machine_info"),
					widget = wibox.container.margin,
					forced_width = 100,
					forced_height = 100,
				},
				machine_info,
				widget = wibox.layout.fixed.horizontal,
				fill_space = true,
				spacing = 10,
			},
			{
				widget = wibox.widget.separator,
				forced_height = 10,
				visible = false,
			},
			control_panel,
			battery,
			widget = wibox.layout.fixed.vertical,
			spacing = 10,
		},
		widget = wibox.container.margin,
		margins = 10,
	},
	bg = beautiful.bg_normal,
	widget = wibox.container.background,
})

awesome.connect_signal("toggle::menu", function()
	if menu.x == -menu_configs.menu_width then
		animate(0.1, 60, -menu_configs.menu_width, 0, "", function(pos)
			menu.x = pos
		end)
	else
		animate(0.1, 60, 0, -menu_configs.menu_width, "", function(pos)
			menu.x = pos
		end)
	end
end)

return menu
