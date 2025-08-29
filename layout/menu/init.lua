local gears = require("gears")
local awful = require("awful")
local wibox = require("wibox")
local naughty = require("naughty")
local beautiful = require("beautiful")
local animate = require("helpers.animate")

local battery = require("layout.bar.modules.battery")
local machine_info = require("layout.menu.modules.machine_info")
local circle_icon = require("components.circle_icon").create_image_icon
local user = require("user")
local control_panel = require("layout.menu.modules.control_panel")
local menu_configs = require("config.menu")
local notifications = require("layout.menu.modules.notifications")
local tabslist = require("layout.menu.modules.tabs")
local music_player = require("layout.menu.modules.music_player")
local weather = require("layout.menu.modules.weather")
local settings = require("layout.menu.modules.settings")
local log = require("helpers.debugger").log

local screen = awful.screen.focused()

local menu = wibox({
	screen = screen,
	visible = true,
	ontop = true,
	x = -DPI(menu_configs.menu_width),
	y = DPI(0),
	height = DPI(menu_configs.menu_height),
	width = DPI(menu_configs.menu_width),
	widget = wibox.container.margin,
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
		margins = DPI(10),
	},
	shape = gears.shape.rounded_rect,
	widget = wibox.container.background,
	bg = beautiful.bg_focus,
})

local container = wibox.widget({
	{
		userinfo,
		{
			{
				circle_icon(user.user_img, beautiful.bg_focus, DPI(100), DPI(100), "her::clicked"),
				widget = wibox.container.margin,
				forced_width = DPI(100),
				forced_height = DPI(100),
			},
			machine_info,
			widget = wibox.layout.fixed.horizontal,
			fill_space = true,
			spacing = DPI(10),
		},
		{
			widget = wibox.widget.separator,
			forced_height = DPI(10),
			visible = false,
		},
		control_panel,
		widget = wibox.layout.fixed.vertical,
		spacing = DPI(10),
	},
	notifications,
	tabslist,
	widget = wibox.layout.align.vertical,
})

awesome.connect_signal("tab::notifications", function()
	container.second = wibox.widget({
		notifications,
		widget = wibox.container.margin,
		top = DPI(10),
		bottom = DPI(10),
	})
end)
awesome.connect_signal("tab::music", function()
	container.second = wibox.widget({
		music_player,
		widget = wibox.container.margin,
		top = DPI(10),
		bottom = DPI(10),
	})
end)
awesome.connect_signal("tab::weather", function()
	container.second = wibox.widget({
		weather,
		widget = wibox.container.margin,
		top = DPI(10),
		bottom = DPI(10),
	})
end)
awesome.connect_signal("tab::settings", function()
	container.second = wibox.widget({
		settings,
		widget = wibox.container.margin,
		top = DPI(10),
		bottom = DPI(10),
	})
end)
menu:setup({
	{
		container,
		widget = wibox.container.margin,
		margins = DPI(10),
	},
	bg = beautiful.bg_normal,
	widget = wibox.container.background,
})

local animating = false
awesome.connect_signal("toggle::menu", function()
	if animating == true then
		return
	end
	animating = true
	if menu.x == 0 then
		animate(0.1, 60, 0, -DPI(menu_configs.menu_width), "", function(pos)
			menu.x = DPI(pos)
		end)
	else
		animate(0.1, 60, -DPI(menu_configs.menu_width), 0, "", function(pos)
			menu.x = DPI(pos)
		end)
	end
	animating = false
end)

return menu
