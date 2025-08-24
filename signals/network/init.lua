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
				--log(status)
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
			--status.SSID = (#status.SSID > 13) and (status.SSID:sub(1, 10) .. "...") or status.SSID
			--log(status)
			if
				prev.WirelessEnabled == status.WirelessEnabled
				and prev.SSID == status.SSID
				and prev.IP == status.IP
				and prev.Connected == status.Connected
			then
				--log("unchanged")
				return
			else
				prev.WirelessEnabled = status.WirelessEnabled
				prev.SSID = status.SSID
				prev.IP = status.IP
				prev.Connected = status.Connected
				--log("changed")
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

-- local sysbus = Gio.bus_get_sync(Gio.BusType.SYSTEM)
--
-- local NM_STATE = {
-- 	[0] = "unknown",
-- 	[10] = "asleep",
-- 	[20] = "disconnected",
-- 	[30] = "disconnecting",
-- 	[40] = "connecting",
-- 	[50] = "connected-local",
-- 	[60] = "connected-site",
-- 	[70] = "connected-global",
-- }
--
-- local NM_DEVICE_STATE = {
-- 	[10] = "unmanaged",
-- 	[20] = "unavailable",
-- 	[30] = "disconnected",
-- 	[40] = "prepare",
-- 	[50] = "config",
-- 	[60] = "need-auth",
-- 	[70] = "ip-config",
-- 	[80] = "ip-check",
-- 	[90] = "secondaries",
-- 	[100] = "activated",
-- 	[110] = "deactivating",
-- 	[120] = "failed",
-- }
--
-- local NM_VPN_STATE = {
-- 	[0] = "unknown",
-- 	[1] = "prepare",
-- 	[2] = "need-auth",
-- 	[3] = "connecting",
-- 	[4] = "getting-ip",
-- 	[5] = "activated",
-- 	[6] = "failed",
-- 	[7] = "disconnecting",
-- }
--
-- Gio.DBusProxy.new_for_bus(
-- 	Gio.BusType.SYSTEM,
-- 	Gio.DBusProxyFlags.NONE,
-- 	nil,
-- 	"org.freedesktop.NetworkManager",
-- 	"/org/freedesktop/NetworkManager",
-- 	"org.freedesktop.DBus.Properties",
-- 	nil,
-- 	function(obj, res)
-- 		local proxy = Gio.DBusProxy.new_finish(res)
-- 		if not proxy then
-- 			naughty.notify({ text = "Could not create NetworkManager DBusProxy" })
-- 			return
-- 		end
--
-- 		proxy:call(
-- 			"GetAll",
-- 			GLib.Variant("(s)", { "org.freedesktop.NetworkManager" }),
-- 			Gio.DBusCallFlags.NONE,
-- 			-1,
-- 			nil,
-- 			function(proxy, res2)
-- 				--log(res2)
-- 				local result, err2 = proxy:call_finish(res2)
-- 				if not result then
-- 					naughty.notify({ text = "Could not get NetworkManager properties: " .. err2 })
-- 					return
-- 				end
-- 				local props = result.value[1]
-- 				--log(result.value[1])
-- 				for k, v in pairs(props) do
-- 					log({ k, v })
-- 				end
-- 			end
-- 		)
--
-- 		proxy.on_g_signal = function(proxyinfo, dbus_id, signal_name, variant)
-- 			log({ proxyinfo, dbus_id, signal_name, variant.value })
-- 			local props = variant.value
-- 			log({ props.State, props.Connectivity, props.WirelessEnabled, props.WirelessHardwareEnabled })
-- 			gears.timer.delayed_call(function()
-- 				awesome.emit_signal("network::status", props)
-- 			end)
-- 		end
-- 	end
-- )

--local proxy = Gio.DBusProxy.new_sync(
--	sysbus,
--	Gio.DBusProxyFlags.NONE,
--	nil,
--	"org.freedesktop.NetworkManager",
--	"/org/freedesktop/NetworkManager",
--	-- "org.freedesktop.DBus.Properties",
--	"org.freedesktop.NetworkManager",
--	nil
--)
--
--local dbus_properties_proxy = Gio.DBusProxy.new_sync(
--	sysbus,
--	Gio.DBusProxyFlags.NONE,
--	nil,
--	"org.freedesktop.NetworkManager",
--	"/org/freedesktop/NetworkManager",
--	"org.freedesktop.DBus.Properties",
--	-- "org.freedesktop.NetworkManager",
--	nil
--)
--
--local function get_all(iface)
--	local ret =
--		dbus_properties_proxy:call_sync("GetAll", GLib.Variant("(s)", { iface }), Gio.DBusCallFlags.NONE, -1, nil)
--	log(ret.value[1])
--	return ret and ret.value[1] or {}
--end
--
--local status = {}
--
--local function emit(local_status)
--	awesome.emit_signal("network::status", local_status)
--end
--
--do
--	local props = get_all("org.freedesktop.NetworkManager")
--	status.State = NM_STATE[(props.State or 20)]
--	status.Connectivity = props.Connectivity or 0 -- 0..4 enum; map if you want
--	status.WirelessEnabled = props.WirelessEnabled
--	status.WirelessHardwareEnable = props.WirelessHardwareEnabled
--end
--gears.timer.delayed_call(function()
--	emit(status)
--end)
--
--proxy.on_g_signal = function(proxyinfo, dbus_id, signal_name, variant)
--	-- log({ proxyinfo, dbus_id, signal_name, variant.value })
--	local props = get_all("org.freedesktop.NetworkManager")
--	log({ props.State, props.Connectivity, props.WirelessEnabled, props.WirelessHardwareEnabled })
--	emit(props)
--	-- status.state = NM_STATE[(props.State or 20)]
--	-- status.connectivity = props.Connectivity or 0 -- 0..4 enum; map if you want
--	-- status.wifi_enabled = props.WirelessEnabled
--	-- status.wifi_hw = props.WirelessHardwareEnabled
--	-- emit(status)
--end

-- dbus.add_match(
-- 	"system",
-- 	"type='signal',"
-- 		.. "sender='org.freedesktop.NetworkManager',"
-- 		.. "path='/org/freedesktop/NetworkManager',"
-- 		.. "interface='org.freedesktop.DBus.Properties'"
-- )
--
-- -- Global NM: StateChanged (emits new state as uint32)
-- dbus.add_match(
-- 	"system",
-- 	"type='signal',"
-- 		.. "sender='org.freedesktop.NetworkManager',"
-- 		.. "path='/org/freedesktop/NetworkManager',"
-- 		.. "interface='org.freedesktop.NetworkManager'"
-- )
--
-- -- Per-device state transitions (all devices)
-- dbus.add_match(
-- 	"system",
-- 	"type='signal',"
-- 		.. "sender='org.freedesktop.NetworkManager',"
-- 		.. "interface='org.freedesktop.NetworkManager.Device'"
-- )
--
-- -- ActiveConnection & VPN
-- dbus.add_match(
-- 	"system",
-- 	"type='signal',"
-- 		.. "sender='org.freedesktop.NetworkManager',"
-- 		.. "interface='org.freedesktop.NetworkManager.Connection.Active'"
-- )
-- dbus.add_match(
-- 	"system",
-- 	"type='signal',"
-- 		.. "sender='org.freedesktop.NetworkManager',"
-- 		.. "interface='org.freedesktop.NetworkManager.VPN.Connection'"
-- )

--
-- -- 1) Global properties (signature: s iface, a{sv} changed, as invalidated)
-- dbus.connect_signal("org.freedesktop.DBus.Properties", function(msg, iface, changed, invalidated)
-- 	if iface ~= "org.freedesktop.NetworkManager" then
-- 		return
-- 	end
--
-- 	if changed.State then
-- 		status.state = NM_STATE[changed.State]
-- 	end
-- 	if changed.Connectivity then
-- 		status.connectivity = changed.Connectivity
-- 	end
-- 	if changed.WirelessEnabled then
-- 		status.wifi_enabled = changed.WirelessEnabled
-- 		naughty.notify({ text = "WirelessEnabled has changed to: " .. tostring(changed.WirelessEnabled) })
-- 	end
-- 	if changed.WirelessHardwareEnabled then
-- 		status.wifi_hw = changed.WirelessHardwareEnabled
-- 	end
--
-- 	-- emit()
-- end)
--
-- -- 2) Global state changed (signature: u new_state)
-- dbus.connect_signal("org.freedesktop.NetworkManager", function(arg1, arg2)
-- 	--local v = tonumber(new_state) or 0
-- 	--status.state = NM_STATE[v] or ("state-" .. v)
-- 	log({ arg1, arg2 })
-- 	-- emit()
-- end)
--
-- -- 3) Per-device transitions (signature: u new, u old, u reason)
-- dbus.connect_signal("org.freedesktop.NetworkManager.Device", function(new, old, reason)
-- 	-- You can track by path if you also listen to the path in the match rule,
-- 	-- but a simple aggregate is often enough for a status icon.
-- 	local nv = tonumber(new) or 0
-- 	status.last_device_state = NM_DEVICE_STATE[nv] or ("dev-" .. nv)
-- 	-- emit()
-- end)
--
-- -- 4) ActiveConnection changes (up/down, type including 'vpn')
-- dbus.connect_signal("org.freedesktop.NetworkManager.Connection.Active", function()
-- 	-- Use lgi to query ActiveConnection objects if you want names, UUIDs, type.
-- 	-- Example: scan /org/freedesktop/NetworkManager/ActiveConnection/* and read Type/Id.
-- 	-- emit()
-- end)
--
-- -- 5) VPN state (signature: u state, u reason)
-- dbus.connect_signal("org.freedesktop.NetworkManager.VPN.Connection", function(vpn_state)
-- 	local vs = tonumber(vpn_state) or 0
-- 	status.vpn = NM_VPN_STATE[vs] or ("vpn-" .. vs)
-- 	-- emit()
-- end)
