local gears = require("gears")
local naughty = require("naughty")
local lgi = require("lgi")
local Gio = lgi.Gio
local GLib = lgi.GLib
local log = require("helpers.debugger").log
local print = require("helpers.debugger").print
local serialize = require("helpers.serialize")
local awful = require("awful")
local user = require("user")

local tmpdir = os.getenv("TMPDIR")
if not tmpdir then
  tmpdir = "/tmp"
end

local data = {
	city = "New Delhi",
	temp = 32,
	condition = "Sunny",
	condition_icon = tmpdir .. "/awesome-weather-icon.png",
	date_time = "10:00 AM",
	wind_speed = 10,
	humidity = 50,
	precipitation = 0,
}

gears.timer({
	timeout = 10,
	autostart = true,
	call_now = true,
	callback = function()
		awful.spawn.easy_async("date +%A,\\ %d\\ %B\\ \\|\\ \\%H:%M\\ %p", function(stdout)
			data.date_time = stdout
			awesome.emit_signal("weather::update", data)
		end)
	end,
})

gears.timer({
	timeout = 180,
	autostart = true,
	call_now = true,
	callback = function()
		awful.spawn.easy_async(
			"curl --request GET --url 'https://weatherapi-com.p.rapidapi.com/current.json?q=new%20delhi' --header 'x-rapidapi-host: weatherapi-com.p.rapidapi.com' --header 'x-rapidapi-key: "
				.. user.rapid_api_key
				.. "'",
			function(stdout)
				data.city = stdout:match('"name":"(.-)"')
				data.temp = stdout:match('"temp_c":(.-),')
				data.condition = stdout:match('"text":"(.-)"')
				data.wind_speed = stdout:match('"wind_kph":(.-),')
				data.humidity = stdout:match('"humidity":(.-),')
				data.precipitation = stdout:match('"precip_mm":(.-),')

				-- temp should never be decimal
				data.temp = math.floor(data.temp)

				local condition_icon = stdout:match('"icon":"(.-)"')
				awful.spawn.easy_async(
					"curl --request GET --url 'https:"
						.. condition_icon
						.. "' --output " .. tmpdir .. "/awesome-"
						.. data.condition
						.. "-weather-icon.png",
					function()
						awesome.emit_signal("weather::update", data)
					end
				)
				awesome.emit_signal("weather::update", data)
			end
		)
	end,
})
