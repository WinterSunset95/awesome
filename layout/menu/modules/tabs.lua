local gears = require("gears")
local awful = require("awful")
local wibox = require("wibox")
local naughty = require("naughty")
local beautiful = require("beautiful")

local function create_button(icon, signal)
	local button = wibox.widget({
		{
			text = icon,
			font = "Cousine Nerd Font Mono Black 25",
			align = "center",
			widget = wibox.widget.textbox,
		},
		widget = wibox.container.background,
		bg = beautiful.bg_focus,
		fg = beautiful.fg_focus,
		buttons = gears.table.join(awful.button({}, 1, function()
			awesome.emit_signal(signal)
		end)),
	})
	return button
end

local notifications = create_button("󰎟", "tab::notifications")
local music = create_button("󰋋", "tab::music")
local weather = create_button("󰖐", "tab::weather")
local settings = create_button("", "tab::settings")

awesome.connect_signal("tab::notifications", function()
	notifications.bg = beautiful.bg_normal

	music.bg = beautiful.bg_focus
	weather.bg = beautiful.bg_focus
	settings.bg = beautiful.bg_focus
end)
awesome.connect_signal("tab::music", function()
	music.bg = beautiful.bg_normal

	notifications.bg = beautiful.bg_focus
	weather.bg = beautiful.bg_focus
	settings.bg = beautiful.bg_focus
end)
awesome.connect_signal("tab::weather", function()
	weather.bg = beautiful.bg_normal

	notifications.bg = beautiful.bg_focus
	music.bg = beautiful.bg_focus
	settings.bg = beautiful.bg_focus
end)
awesome.connect_signal("tab::settings", function()
	settings.bg = beautiful.bg_normal

	notifications.bg = beautiful.bg_focus
	music.bg = beautiful.bg_focus
	weather.bg = beautiful.bg_focus
end)

local tabslist = wibox.widget({
	widget = wibox.container.background,
	bg = "#00000000",
	{
		layout = wibox.layout.flex.horizontal,
		notifications,
		music,
		weather,
		settings,
	},
})

gears.timer.delayed_call(function()
	awesome.emit_signal("tab::settings")
end)

return tabslist
