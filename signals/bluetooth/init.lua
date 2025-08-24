local gears = require("gears")
local naughty = require("naughty")
local lgi = require("lgi")
local Gio = lgi.Gio
local GLib = lgi.GLib
local log = require("helpers.debugger").log
local print = require("helpers.debugger").print
local serialize = require("helpers.serialize")
local awful = require("awful")

local prev = {}
local function get_status()
	awful.spawn.easy_async_with_shell("bluetoothctl show", function(stdout)
		local state = {}
		local powered = stdout:match("Powered:%s*(%S+)")
		if powered == "yes" then
			state.Powered = true
			awful.spawn.easy_async_with_shell("bluetoothctl devices Connected | head -n 1", function(stdout2)
				local mac, name = stdout2:match("^Device%s+([%x:]+)%s+(.+)$")
				state.Address = tostring(mac) or "00:00:00:00:00:00"
				state.Name = tostring(name) or "Bluetooth"
				state.Name = state.Name:gsub("\n", "")
				state.Name = (#state.Name > 13) and (state.Name:sub(1, 10) .. "...") or state.Name
				if prev.Powered == state.Powered and prev.Address == state.Address and prev.Name == state.Name then
					return
				else
					prev.Powered = state.Powered
					prev.Address = state.Address
					prev.Name = state.Name
				end
				awesome.emit_signal("bluetooth::status", state)
			end)
		else
			state.Powered = false
			state.Address = "00:00:00:00:00:00"
			state.Name = "Bluetooth"
			if prev.Powered == state.Powered and prev.Address == state.Address and prev.Name == state.Name then
				return
			else
				prev.Powered = state.Powered
				prev.Address = state.Address
				prev.Name = state.Name
			end
			awesome.emit_signal("bluetooth::status", state)
		end
	end)
end

gears.timer({
	timeout = 5,
	autostart = true,
	call_now = true,
	callback = get_status,
})
