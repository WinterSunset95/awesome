local gears = require("gears")
local naughty = require("naughty")
local lgi = require("lgi")
local Gio = lgi.Gio
local GLib = lgi.GLib
local log = require("helpers.debugger").log
local print = require("helpers.debugger").print
local serialize = require("helpers.serialize")
local awful = require("awful")

awful.spawn.easy_async_with_shell("killall pactl", function(stdout) end)

awful.spawn.easy_async_with_shell("pactl get-sink-volume @DEFAULT_SINK@", function(stdout)
	local volume = stdout:match("(%d+)%%")
	local vol_without_percentage = string.gsub(volume, "%%", "") or 0
	awesome.emit_signal("volume::update", tonumber(vol_without_percentage))
end)

awful.spawn.with_line_callback("pactl subscribe", {
	stdout = function(line)
		if string.find(line, "change") then
			awful.spawn.easy_async_with_shell("pactl get-sink-volume @DEFAULT_SINK@", function(stdout)
				local volume = stdout:match("(%d+)%%")
				local vol_without_percentage = string.gsub(volume, "%%", "") or 0
				awesome.emit_signal("volume::update", tonumber(vol_without_percentage))
			end)
		end
	end,
})
