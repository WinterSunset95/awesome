-- If LuaRocks is installed, make sure that packages installed through it are
-- found (e.g. lgi). If LuaRocks is not installed, do nothing.
pcall(require, "luarocks.loader")

-- Standard awesome library
local gears = require("gears")
local awful = require("awful")
require("awful.autofocus")
local beautiful = require("beautiful")
local naughty = require("naughty")
local menubar = require("menubar")
local globalkeys = require("bindings.global.key")
local resize_mode_keys = require("bindings.global.resize_mode")
local mouse_mode = require("bindings.global.mouse_mode")
local mouse_mode_keys = gears.table.join(mouse_mode, globalkeys)
require("awful.hotkeys_popup.keys")
DPI = beautiful.xresources.apply_dpi

beautiful.init(gears.filesystem.get_configuration_dir() .. "themes/custom/theme.lua")

local mod = require("bindings.mod")
require("bindings")
require("rules")
require("signals")
require("config.autostart")
require("layout.bar")
require("layout.menu")

-- {{{ Error handling
-- Check if awesome encountered an error during startup and fell back to
-- another config (This code will only ever execute for the fallback config)
if awesome.startup_errors then
	naughty.notify({
		preset = naughty.config.presets.critical,
		title = "Oops, there were errors during startup!",
		text = awesome.startup_errors,
	})
end

-- Handle runtime errors after startup
do
	local in_error = false
	awesome.connect_signal("debug::error", function(err)
		-- Make sure we don't go into an endless error loop
		if in_error then
			return
		end
		in_error = true

		naughty.notify({
			preset = naughty.config.presets.critical,
			title = "Oops, an error happened!",
			text = tostring(err),
		})
		in_error = false
	end)
end
-- }}}

-- Menubar configuration
menubar.utils.terminal = "alacritty" -- Set the terminal for applications that require it
-- }}}

root.keys(globalkeys)
local mode = "normal"
awesome.connect_signal("toggle::resize_mode", function()
  if mode == "normal" then
    mode = "resize"
    root.keys(resize_mode_keys)
    naughty.notify({
      preset = naughty.config.presets.normal,
      title = "Resize Mode",
      text = "Resize mode activated. Press m to exit.",
      timeout = 5,
    })
  else
    mode = "normal"
    root.keys(globalkeys)
    naughty.notify({
      preset = naughty.config.presets.normal,
      title = "Resize Mode",
      text = "Resize mode deactivated.",
      timeout = 5,
    })
  end
end)

awesome.connect_signal("toggle::mouse_mode", function()
  if mode == "normal" then
    mode = "mouse"
    root.keys(mouse_mode_keys)
    naughty.notify({
      preset = naughty.config.presets.normal,
      title = "Mouse Mode",
      text = "Mouse mode activated",
      timeout = 5,
    })
  else
    mode = "normal"
    root.keys(globalkeys)
    naughty.notify({
      preset = naughty.config.presets.normal,
      title = "Mouse Mode",
      text = "Mouse mode deactivated.",
      timeout = 5,
    })
  end
end)
