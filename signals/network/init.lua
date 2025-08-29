local gears = require("gears")
local naughty = require("naughty")
local lgi = require("lgi")
local Gio = lgi.Gio
local GLib = lgi.GLib
local log = require("helpers.debugger").log
local print = require("helpers.debugger").print
local serialize = require("helpers.serialize")
local awful = require("awful")
local command_exists = require("helpers.commands").command_exists

local prev = {}

log(command_exists("ls"))
if command_exists("nmcli") then
  return
end
naughty.notify({ text = "NMCLI doesn't exist" })
local function get_network_status()
	-- First let's get wifi status
	awful.spawn.easy_async_with_shell(
		[[
  nmcli -t -f WIFI g;
  nmcli -t -f GENERAL.STATE,IP4.ADDRESS dev show | head -n 2;
  nmcli -t -f NAME connection show --active | head -n 1;
  ]],
		function(stdout)
			local status = {}
			--string.gsub(stdout, " (string)", "")
			local lines = {}
			for line in stdout:gmatch("[^\r\n]+") do
				--line.gsub("%(string%)", "")
				string.gsub(line, "%(string%)", "")
				table.insert(lines, line)
			end
			if lines[1] == "enabled" then
				status.WirelessEnabled = true
			else
				status.WirelessEnabled = false
			end

			if status.WirelessEnabled == false then
				awesome.emit_signal("network::status", status)
				return
			end

			if string.find(lines[2], "connected") then
				status.Connected = true
			else
				status.Connected = false
			end

			local o1, o2, o3, o4 = lines[3]:match("(%d%d?%d?)%.(%d%d?%d?)%.(%d%d?%d?)%.(%d%d?%d?)")
			local ip_address = string.format("%s.%s.%s.%s", o1, o2, o3, o4)
			status.IP = ip_address
			status.SSID = lines[4]
			status.SSID = status.SSID:gsub("\n", "  ")
			if
				prev.WirelessEnabled == status.WirelessEnabled
				and prev.SSID == status.SSID
				and prev.IP == status.IP
				and prev.Connected == status.Connected
			then
				return
			else
				prev.WirelessEnabled = status.WirelessEnabled
				prev.SSID = status.SSID
				prev.IP = status.IP
				prev.Connected = status.Connected
			end
			awesome.emit_signal("network::status", status)
		end
	)
end

gears.timer({
	timeout = 5,
	autostart = true,
	call_now = true,
	callback = get_network_status,
})
