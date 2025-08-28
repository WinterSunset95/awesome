local gears = require("gears")
local awful = require("awful")
local wibox = require("wibox")
local naughty = require("naughty")
local beautiful = require("beautiful")
local log = require("helpers.debugger").log
local create_separator = require("components.separator")

local clouds = {
	cloudy = "󰖐",
	fog = "󰖑",
	hail = "󰖒",
	hazy = "󰼰",
	hurricane = "󰢘",
	lightning = "󰖓",
	night = "󰖔",
	pouring = "󰖖",
	rainy = "󰖗",
	snowy = "󰖘",
	sunny = "󰖙",
	sunset = "󰖚",
	tornado = "󰼸",
	windy = "󰖝",
	partly_cloudy = "󰖕",
	partly_rainy = "󰼳",
	partly_snowy = "󰼴",
	heavy_snow = "󰼶",
	night_cloudy = "󰼱",
}

local city = wibox.widget({
	text = "Delhi",
	font = "cousine nerd font mono black 20",
	align = "center",
	widget = wibox.widget.textbox,
})

local weather_status = wibox.widget({
	text = "Mostly Sunny",
	font = "cousine nerd font mono black 15",
	align = "center",
	valign = "bottom",
	widget = wibox.widget.textbox,
})

local temperature = wibox.widget({
	text = "25°",
	font = "cousine nerd font mono black 170",
	align = "center",
	valign = "top",
	widget = wibox.widget.textbox,
	point = { x = 0, y = -DPI(30) },
})

local temp_image = wibox.widget({
	image = "/tmp/awesome-Mist-weather-icon.png",
	widget = wibox.widget.imagebox,
	point = { x = DPI(130), y = DPI(20) },
})

local temp_stack = wibox.widget({
	temp_image,
	temperature,
	layout = wibox.layout.manual,
})

local day = wibox.widget({
	text = "Monday",
	font = "cousine nerd font mono black 15",
	align = "center",
	valign = "top",
	widget = wibox.widget.textbox,
})

local function footer_widget(icon, value, name)
	local widget1 = wibox.widget({
		widget = wibox.widget.textbox,
		text = icon,
		font = "cousine nerd font mono black 70",
		align = "center",
	})
	local widget2 = wibox.widget({
		widget = wibox.widget.textbox,
		text = value,
		font = "cousine nerd font mono black 20",
		align = "center",
	})
	local widget3 = wibox.widget({
		widget = wibox.widget.textbox,
		text = name,
		font = "cousine nerd font mono black 10",
		align = "center",
	})
	local stack = wibox.widget({
		widget1,
		widget2,
		widget3,
		layout = wibox.layout.fixed.vertical,
	})
	return {
		main = stack,
		widget1 = widget1,
		widget2 = widget2,
		widget3 = widget3,
	}
end

local precipitation = footer_widget("󰖖", "0 mm", "Precipitation")
local wind = footer_widget("󰖝", "0 km/h", "Wind")
local humidity = footer_widget("󰖑", "0 %", "Humidity")

awesome.connect_signal("weather::update", function(data)
	city.text = data.city
	weather_status.text = "(" .. data.condition .. ")"
	temperature.text = data.temp .. "°"
	day.text = data.date_time
	temp_image.image = data.condition_icon
	precipitation.widget2.text = data.precipitation .. "mm"
	wind.widget2.text = data.wind_speed .. "km/h"
	humidity.widget2.text = data.humidity .. "%"
end)

local main = wibox.widget({
	{
		create_separator(50),
		city,
		{
			weather_status,
			temp_stack,
			day,
			layout = wibox.layout.align.vertical,
		},
		layout = wibox.layout.fixed.vertical,
		spacing = 0,
	},
	widget = wibox.container.background,
	fg = beautiful.fg_focus,
})

local footer = wibox.widget({
	{
		precipitation.main,
		wind.main,
		humidity.main,
		layout = wibox.layout.flex.horizontal,
	},
	shape = gears.shape.rounded_rect,
	widget = wibox.container.background,
	bg = beautiful.bg_focus,
	fg = beautiful.fg_focus,
})

local container = wibox.widget({
	main,
	footer,
	widget = wibox.layout.ratio.vertical,
	spacing = DPI(10),
})
container:ajust_ratio(2, 0.7, 0.3, 0)

local margined_container = wibox.widget({
	container,
	widget = wibox.container.margin,
	bottom = DPI(10),
})

return margined_container
