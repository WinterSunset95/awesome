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

local mouse_down = false
awesome.connect_signal("toggle::mouse_mode", function()
  mouse_down = false
end)

local mouse_mode_keys = gears.table.join(
  awful.key({ }, "KP_Up", function()
    mouse.coords({ y = mouse.coords().y - 20 })
  end, { description = "Move mouse up", group = "mouse" }),
  awful.key({ }, "KP_Left", function()
    mouse.coords({ x = mouse.coords().x - 20 })
  end, { description = "Move mouse left", group = "mouse" }),
  awful.key({ }, "KP_Down", function()
    mouse.coords({ y = mouse.coords().y + 20 })
  end, { description = "Move mouse down", group = "mouse" }),
  awful.key({ }, "KP_Right", function()
    mouse.coords({ x = mouse.coords().x + 20 })
  end, { description = "Move mouse right", group = "mouse" }),

  awful.key({ }, "KP_Home", function()
    if mouse_down then
      root.fake_input("button_release", 1)
      mouse_down = false
    else
      root.fake_input("button_press", 1)
      mouse_down = true
    end
  end, { description = "Mouse left click hold", group = "mouse" }),
  awful.key({ }, "KP_Prior", function()
    root.fake_input("button_press", 3)
    root.fake_input("button_release", 3)
  end, { description = "Mouse right click", group = "mouse" }),
  awful.key({ }, "KP_Begin", function()
    root.fake_input("button_press", 1)
    root.fake_input("button_release", 1)
  end, { description = "Mouse left click", group = "mouse" }),
  awful.key({ }, "KP_End", function()
    root.fake_input("button_press", 4)
    root.fake_input("button_release", 4)
  end, { description = "Mouse scroll up", group = "mouse" }),
  awful.key({ }, "KP_Next", function()
    root.fake_input("button_press", 5)
    root.fake_input("button_release", 5)
  end, { description = "Mouse scroll down", group = "mouse" })
)

return mouse_mode_keys
