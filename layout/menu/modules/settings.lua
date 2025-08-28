local gears = require("gears")
local awful = require("awful")
local wibox = require("wibox")
local naughty = require("naughty")
local beautiful = require("beautiful")
local log = require("helpers.debugger").log
local user = require("user")

local create_controller = require("components.control_button")

local float = create_controller("󰉨", "Menu Float", "control_button::float")
awesome.connect_signal("control_button::float", function()
	local role_button = float:get_children_by_id("role_button")[1]
	user.bar_floating = not user.bar_floating
	if user.bar_floating == false then
		role_button.bg = beautiful.bg_focus
	else
		role_button.bg = beautiful.fg_normal
	end
end)

local row1 = wibox.widget({
	float,
	layout = wibox.layout.flex.horizontal,
})

local container = wibox.widget({
	{
		row1,
		layout = wibox.layout.fixed.vertical,
	},
	widget = wibox.container.margin,
	margins = 10,
})

return container
