local awful = require("awful")
local hotkeys_popup = require("awful.hotkeys_popup")
require("awful.hotkeys_popup.keys")
local apps = require("config.apps")
local mod = require("bindings.mod")

local naughty = require("naughty")
local wibox = require("wibox")
local beautiful = require("beautiful")
local gears = require("gears")

local s = awful.screen.focused()
local screen_geom = s.geometry

local resize_mode_keys = gears.table.join(
  awful.key({ }, "h", function()
    awful.client.incwfact(-0.01)
  end, { description = "decrease master width factor", group = "resize" }),
  awful.key({ }, "l", function()
    awful.client.incwfact(0.01)
  end, { description = "increase master width factor", group = "resize" }),
  awful.key({ }, "j", function()
    awful.client.incwfact(0.01)
  end, { description = "increase master height factor", group = "resize" }),
  awful.key({ }, "k", function()
    awful.client.incwfact(-0.01)
  end, { description = "decrease master height factor", group = "resize" }),
  awful.key({ }, "m", function()
    awesome.emit_signal("toggle::resize_mode")
  end, { description = "exit resize mode", group = "resize" })
)

return resize_mode_keys
