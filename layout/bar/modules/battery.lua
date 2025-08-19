local awful = require("awful")
local wibox = require("wibox")
local gears = require("gears")
local beautiful = require("beautiful")
local naughty = require("naughty")
local gfs = require("gears.filesystem")

local function find_battery_path()
	local power_path = "/sys/class/power_supply"
	local handle = io.popen("ls " .. power_path)
	if handle == nil then
		naughty.notify({
			title = "Error",
			text = "No battery found",
		})
		return
	end
	local folders = handle:read("*a")
	handle:close()

	for device_name in string.gmatch(folders, "BAT%d+") do
		return power_path .. "/" .. device_name
	end

	return nil
end

local battery_path = find_battery_path()
if battery_path == nil then
	naughty.notify({
		title = "Error",
		text = "No battery found",
	})
	return
end

local bat_status = io.open(battery_path .. "/status")
local charge = io.open(battery_path .. "/capacity")
if bat_status == nil or charge == nil then
	naughty.notify({
		title = "Error",
		text = "Could not get battery status or charge",
	})
	return
end
local status = bat_status:read("*a")
bat_status:close()
local charge_level = charge:read("*a")
charge:close()

local batttery_widget_template = {
	{
		id = "text_role",
		text = "0",
		font = "Cousine Nerd Font Mono Black 12",
		align = "center",
		valign = "center",
		widget = wibox.widget.textbox,
	},
	widget = wibox.container.arcchart,
	max_value = 100,
	bg = "#00000000",
	thickness = 2,
	value = 0,
	start_angle = 4.71238898,
}

local batttery_widget = wibox.widget(batttery_widget_template)

awful.widget.watch('bash -c "cat ' .. battery_path .. '/capacity"', 10, function(_, stdout)
	batttery_widget:set_value(tonumber(stdout))
	local mytextbox = batttery_widget:get_children_by_id("text_role")[1]
	mytextbox:set_text(stdout)
end, batttery_widget)

return batttery_widget
