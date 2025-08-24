local gears = require("gears")
local naughty = require("naughty")
local lgi = require("lgi")
local Gio = lgi.Gio
local GLib = lgi.GLib
local log = require("helpers.debugger").log
local print = require("helpers.debugger").print
local serialize = require("helpers.serialize")
local awful = require("awful")

awful.spawn.with_line_callback("inotifywait -m -e modify /sys/class/backlight/intel_backlight/brightness", {
	stdout = function(output)
		awful.spawn.easy_async_with_shell(
			[[
    cat /sys/class/backlight/intel_backlight/brightness;
    cat /sys/class/backlight/intel_backlight/max_brightness;
    ]],
			function(stdout)
				local lines = {}
				for line in stdout:gmatch("[^\r\n]+") do
					table.insert(lines, line)
				end
				local value = lines[1]
				local max = lines[2]
				local percent = (value / max) * 100
				awesome.emit_signal("brightness::update", percent)
			end
		)
	end,
})
