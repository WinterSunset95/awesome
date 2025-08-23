local gears = require("gears")
local awful = require("awful")
local wibox = require("wibox")
local naughty = require("naughty")
local beautiful = require("beautiful")

local user = require("user")
local imageicon = require("components.circle_icon")
local control_button = require("components.control_button")
local log = require("helpers.debugger").log
local rounded_rect = require("components.rounded_rect")
local slider = require("components.slider_big")

--local wifi_button = control_button("󰖩", "WiFi", "wifi_button:click")
local wifi_button = rounded_rect("wifi_button:")
local wifi_role_logo = wifi_button:get_children_by_id("role_logo")[1]
local wifi_role_name = wifi_button:get_children_by_id("role_name")[1]
local wifi_role_id = wifi_button:get_children_by_id("role_id")[1]
local wifi_role_container = wifi_button:get_children_by_id("role_container")[1]

local wifi_status = false
local wifi_status_while_click = not wifi_status
awesome.connect_signal("wifi_button:1", function()
	if wifi_status_while_click == wifi_status then
		naughty.notify({ title = "Patience!!", text = "Wait for wifi status to update!!" })
		return
	end
	wifi_status_while_click = wifi_status
	if wifi_status then
		naughty.notify({ title = "Wifi update", text = "Turning wifi off!! Please wait!!" })
		awful.spawn.easy_async_with_shell("nmcli radio wifi off", function(stdout) end)
	else
		naughty.notify({ title = "Wifi update", text = "Turning wifi on!! Please wait!!" })
		awful.spawn.easy_async_with_shell("nmcli radio wifi on", function(stdout) end)
	end
end)

awesome.connect_signal("network::status", function(state)
	wifi_status = state.WirelessEnabled
	wifi_status_while_click = not wifi_status
	if state.WirelessEnabled == true then
		naughty.notify({ title = "Wi-Fi update", text = "Connected to: " .. state.SSID })
		wifi_role_container:set_bg(beautiful.bg_focus)
		wifi_role_container:set_fg(beautiful.fg_focus)
		wifi_role_name.text = state.SSID
		wifi_role_id.text = state.IP
	else
		naughty.notify({ title = "Wi-Fi update", text = "Disconnected" })
		wifi_role_container:set_bg(beautiful.fg_normal)
		wifi_role_container:set_fg(beautiful.bg_normal)
		wifi_role_name.text = "Wi-Fi"
		wifi_role_id.text = "off"
	end
end)

local bluetooth_button = rounded_rect("bluetooth_button:")
local bluetooth_role_logo = bluetooth_button:get_children_by_id("role_logo")[1]
local bluetooth_role_name = bluetooth_button:get_children_by_id("role_name")[1]
local bluetooth_role_id = bluetooth_button:get_children_by_id("role_id")[1]
local bluetooth_role_container = bluetooth_button:get_children_by_id("role_container")[1]
bluetooth_role_container.buttons = gears.table.join(awful.button({}, 1, function()
	naughty.notify({ text = "Bluetooth button clicked!!" })
end))
bluetooth_role_logo.text = ""
bluetooth_role_name.text = "Bluetooth"

local vol_slider_obj = slider()
local vol_slider = vol_slider_obj.slider
local vol_display = vol_slider_obj.displayer
local vol_control = vol_slider_obj.controller
awful.spawn.easy_async_with_shell("pactl get-sink-volume @DEFAULT_SINK@", function(stdout)
	local volume = stdout:match("(%d+)%%")
	local vol_without_percentage = string.gsub(volume, "%%", "")
	vol_display.value = tonumber(vol_without_percentage)
	log(vol_without_percentage)
end)
vol_control:connect_signal("property::value", function(params)
	vol_display.value = params.value
	awful.spawn.easy_async_with_shell(
		"pactl set-sink-volume @DEFAULT_SINK@ " .. params.value .. "%",
		function(stdout) end
	)
	log(params.value)
end)

local control_panel = wibox.widget({
	{
		wifi_button,
		bluetooth_button,
		layout = wibox.layout.flex.horizontal,
		spacing = 10,
	},
	{
		vol_slider,
		widget = wibox.container.background,
	},
	layout = wibox.layout.fixed.vertical,
	spacing = 10,
})

return control_panel
