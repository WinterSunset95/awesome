local gears = require("gears")
local naughty = require("naughty")
local lgi = require("lgi")
local Gio = lgi.Gio
local GLib = lgi.GLib
local log = require("helpers.debugger").log
local print = require("helpers.debugger").print
local serialize = require("helpers.serialize")
local awful = require("awful")

awful.spawn.easy_async_with_shell("killall playerctl", function() end)

local playerstatus = {
	playing = false,
	artist = "No songs playing",
	title = "No songs playing",
	artUrl = "blank",
	length = 10,
}

gears.timer.delayed_call(function()
	awful.spawn.with_line_callback("playerctl --follow status", {
		stdout = function(line)
			if line == "" or line == nil then
				return
			end
			if line == "Playing" then
				playerstatus.playing = true
			elseif line == "Paused" then
				playerstatus.playing = false
			end
			awesome.emit_signal("music::update", playerstatus)
		end,
	})

	awful.spawn.with_line_callback(
		'playerctl --follow metadata -f "{{artist}}:{{title}}:{{mpris:length}}:{{mpris:artUrl}}"',
		{
			stdout = function(line)
				if line == "" or line == nil then
					return
				end
				local artist, title, length, artUrl = line:match("([^:]+):([^:]+):([^:]+):(.+)")
				local length_sec = tonumber(length) / 1000000
				local image_path = "/tmp/" .. title .. ".jpg"
				awful.spawn.easy_async_with_shell("curl -s -o '" .. image_path .. "' '" .. artUrl .. "'", function()
					playerstatus.artist = artist
					playerstatus.title = title
					playerstatus.artUrl = image_path
					playerstatus.length = length_sec
					awesome.emit_signal("music::update", playerstatus)
				end)
			end,
		}
	)

	awful.spawn.with_line_callback("playerctl --follow position", {
		stdout = function(line)
			if line == "" or line == nil then
				return
			end
			playerstatus.value = tonumber(line)
			awesome.emit_signal("music::update", playerstatus)
		end,
	})
end)
