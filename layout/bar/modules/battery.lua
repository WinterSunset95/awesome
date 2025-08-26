local awful = require("awful")
local wibox = require("wibox")
local gears = require("gears")
local beautiful = require("beautiful")
local naughty = require("naughty")
local gfs = require("gears.filesystem")

local batttery_widget = wibox.widget({
	{
		id = "text_role",
		text = "0",
		font = "Cousine Nerd Font Mono Black 12",
		align = "center",
		valign = "center",
		widget = wibox.widget.textbox,
		forced_width = 40,
		forced_height = 40,
	},
	widget = wibox.container.arcchart,
	max_value = 100,
	bg = "#00000000",
	thickness = 5,
	value = 0,
	start_angle = 4.71238898,
})

local function find_battery_path()
	local power_path = "/sys/class/power_supply"
	local handle = io.popen("ls " .. power_path)
	if handle == nil then
		naughty.notify({
			title = "Error",
			text = "No battery found",
		})
		return nil
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
	return batttery_widget
end

local bat_status = io.open(battery_path .. "/status")
local charge = io.open(battery_path .. "/capacity")
if bat_status == nil or charge == nil then
	naughty.notify({
		title = "Error",
		text = "Could not get battery status or charge",
	})
	return batttery_widget
end
bat_status:close()
charge:close()

local function battery_color(battery)
	if battery < 15 then
		return "#ff0000"
	elseif battery < 30 then
		return "#0ff000"
	elseif battery < 50 then
		return "#00ff00"
	elseif battery < 70 then
		return "#000ff0"
	else
		return "#000ff0"
	end
end

awful.widget.watch('bash -c "cat ' .. battery_path .. '/capacity"', 10, function(_, stdout)
	batttery_widget:set_value(tonumber(stdout) or 0)
	batttery_widget:set_colors({ battery_color(tonumber(stdout) or 0) })
	local mytextbox = batttery_widget:get_children_by_id("text_role")[1]
	mytextbox:set_text(stdout or 0)
end, batttery_widget)

return batttery_widget
