local awful = require("awful")
local wibox = require("wibox")
local gears = require("gears")
local beautiful = require("beautiful")
local naughty = require("naughty")
local gfs = require("gears.filesystem")

local function find_battery_path()
	local power_path = "/sys/class/power_supply"
	local handle = io.popen("ls " .. power_path) or nil
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

local batttery_widget =  wibox.widget({
	{
		id = "text_role",
		text = "0",
		font = "Cousine Nerd Font Mono Black 12",
		align = "center",
		valign = "center",
		widget = wibox.widget.textbox,
		forced_width = DPI(40),
		forced_height = DPI(40),
	},
	widget = wibox.container.arcchart,
	max_value = 100,
	bg = "#00000000",
	thickness = DPI(5),
	value = 0,
	start_angle = 4.71238898,
})

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

gears.timer({
  timeout = 10,
  autostart = true,
  call_now = true,
  callback = function()
    local bat_status2 = io.open(battery_path .. "/status")
    local charge2 = io.open(battery_path .. "/capacity")
    if bat_status2 == nil or charge2 == nil then
      naughty.notify({
        title = "Error",
        text = "Could not get battery status or charge",
      })
      return
    end
    local battery_level = tonumber(charge2:read("*all")) or 0
    local mytextbox = batttery_widget:get_children_by_id("text_role")[1]
    mytextbox.text = tostring(battery_level)
    local charge_status = bat_status2:read("*all")
    batttery_widget.value = battery_level
    if charge_status:match("Charging") then
      batttery_widget:set_colors({ "#00ff00" })
    elseif charge_status:match("Discharging") then
      batttery_widget:set_colors({ battery_color(battery_level) })
    end
    if battery_level < 50 and charge_status:match("Discharging") then
      naughty.notify({
        title = "Battery low",
        text = "Battery level is at " .. battery_level .. "%",
        timeout = 5,
      })
    elseif battery_level < 20 and charge_status:match("Discharging") then
      naughty.notify({
        title = "Battery critical",
        text = "Battery level is at " .. battery_level .. "%",
        preset = naughty.config.presets.critical,
      })
    end
    bat_status2:close()
    charge2:close()
  end,
})

return batttery_widget
