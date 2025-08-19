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

local myawesomemenu = {
	{
		"hotkeys",
		function()
			hotkeys_popup.show_help(nil, awful.screen.focused())
		end,
	},
	{ "manual", apps.manual_cmd },
	{ "edit config", apps.editor_cmd .. " " .. awesome.conffile },
	{ "restart", awesome.restart },
	{
		"quit",
		function()
			awesome.quit()
		end,
	},
}

local mymainmenu = awful.menu({
	items = {
		{ "awesome", myawesomemenu, beautiful.awesome_icon },
		{ "open terminal", apps.terminal },
	},
})

local popup_x = screen_geom.x + (screen_geom.width / 2) - 100
local popup_y = screen_geom.y + (screen_geom.height / 2) - 100

local layout_popup = awful.popup({
	screen = awful.screen.focused(),
	visible = false,
	ontop = true,
	widget = {
		{
			awful.widget.layoutbox(awful.screen.focused()),
			margins = 10,
			widget = wibox.container.margin,
		},
		bg = beautiful.wibar_bg,
		widget = wibox.container.background,
		forced_width = 200,
		forced_height = 200,
	},
	x = popup_x,
	y = popup_y,
})

local function print_layout()
	naughty.notify({
		preset = naughty.config.presets.normal,
		title = "Current Layout",
		text = awful.layout.getname(awful.layout.get(s)),
		timeout = 1,
	})
	layout_popup.visible = true
	gears.timer({
		timeout = 1,
		autostart = true,
		single_shot = true,
		callback = function()
			layout_popup.visible = false
		end,
	})
end

local globalkeys = gears.table.join(
	awful.key({ mod.super }, "s", hotkeys_popup.show_help, { description = "show help", group = "awesome" }),
	awful.key({ mod.super }, "Left", awful.tag.viewprev, { description = "view previous", group = "tag" }),
	awful.key({ mod.super }, "Right", awful.tag.viewnext, { description = "view next", group = "tag" }),
	awful.key(
		{ mod.super },
		"Tab",
		awful.tag.history.restore,
		{ description = "Go back to previous workspace", group = "tag" }
	),
	awful.key({ "Mod1" }, "Tab", function()
		awful.client.focus.history.previous()
		if client.focus then
			client.focus:raise()
		end
	end, { description = "Go to previous window", group = "client" }),

	awful.key({ mod.super }, "j", function()
		awful.client.focus.byidx(1)
	end, { description = "focus next by index", group = "client" }),
	awful.key({ mod.super }, "k", function()
		awful.client.focus.byidx(-1)
	end, { description = "focus previous by index", group = "client" }),
	awful.key({ mod.super }, "w", function()
		mymainmenu:show()
	end, { description = "show main menu", group = "awesome" }),

	-- Layout manipulation
	awful.key({ mod.super, mod.shift }, "j", function()
		awful.client.swap.byidx(1)
	end, { description = "swap with next client by index", group = "client" }),
	awful.key({ mod.super, mod.shift }, "k", function()
		awful.client.swap.byidx(-1)
	end, { description = "swap with previous client by index", group = "client" }),
	awful.key({ mod.super, mod.ctrl }, "j", function()
		awful.screen.focus_relative(1)
	end, { description = "focus the next screen", group = "screen" }),
	awful.key({ mod.super, mod.ctrl }, "k", function()
		awful.screen.focus_relative(-1)
	end, { description = "focus the previous screen", group = "screen" }),
	awful.key(
		{ mod.super },
		"u",
		awful.client.urgent.jumpto,
		{ description = "jump to urgent client", group = "client" }
	),

	-- Standard program
	awful.key({ mod.super }, "Return", function()
		awful.spawn(apps.terminal)
	end, { description = "open a terminal", group = "launcher" }),
	awful.key({ mod.super, mod.shift }, "r", awesome.restart, { description = "reload awesome", group = "awesome" }),
	awful.key({ mod.super, mod.shift }, "e", awesome.quit, { description = "quit awesome", group = "awesome" }),

	awful.key({ mod.super }, "l", function()
		awful.tag.incmwfact(0.05)
	end, { description = "increase master width factor", group = "layout" }),
	awful.key({ mod.super }, "h", function()
		awful.tag.incmwfact(-0.05)
	end, { description = "decrease master width factor", group = "layout" }),
	awful.key({ mod.super, mod.shift }, "h", function()
		awful.tag.incnmaster(1, nil, true)
	end, { description = "increase the number of master clients", group = "layout" }),
	awful.key({ mod.super, mod.shift }, "l", function()
		awful.tag.incnmaster(-1, nil, true)
	end, { description = "decrease the number of master clients", group = "layout" }),
	awful.key({ mod.super, mod.ctrl }, "h", function()
		awful.tag.incncol(1, nil, true)
	end, { description = "increase the number of columns", group = "layout" }),
	awful.key({ mod.super, mod.ctrl }, "l", function()
		awful.tag.incncol(-1, nil, true)
	end, { description = "decrease the number of columns", group = "layout" }),

	awful.key({ mod.super }, "space", function()
		awful.layout.inc(1)
		print_layout()
	end, { description = "Select next layout", group = "layout" }),

	awful.key({ mod.super, mod.shift }, "space", function()
		awful.layout.inc(-1)
		print_layout()
	end, { description = "Select previous layout", group = "layout" }),

	awful.key({ mod.super, mod.ctrl }, "n", function()
		local c = awful.client.restore()
		-- Focus restored client
		if c then
			c:emit_signal("request::activate", "key.unminimize", { raise = true })
		end
	end, { description = "restore minimized", group = "client" }),

	-- Prompt
	awful.key({ mod.super }, "r", function()
		awful.screen.focused().mypromptbox:run()
	end, { description = "run prompt", group = "launcher" }),

	awful.key({ mod.super }, "x", function()
		awful.prompt.run({
			prompt = "Run Lua code: ",
			textbox = awful.screen.focused().mypromptbox.widget,
			exe_callback = awful.util.eval,
			history_path = awful.util.get_cache_dir() .. "/history_eval",
		})
	end, { description = "lua execute prompt", group = "awesome" }),
	-- Screenshot
	awful.key({ mod.super }, "p", function()
		awful.spawn("flameshot full")
	end, { description = "Screenshot the full screen", group = "screen" }),
	awful.key({ mod.super, mod.shift }, "p", function()
		awful.spawn("flameshot gui --clipboard")
	end, { description = "Screenshot the selected area", group = "screen" }),
	--

	awful.key({ mod.super }, "y", function()
		awful.spawn("rofi -modi 'clipboard:greenclip print' -show clipboard -run-command '{cmd}'")
	end, { description = "Rofi clipboard", group = "launcher" }),

	awful.key({ mod.super }, "d", function()
		awful.spawn("rofi -modi drun,run -show drun -icon-theme 'Papirus' -show-icons")
	end, { description = "Rofi Launcher", group = "launcher" }),

	awful.key({ mod.super, mod.ctrl }, "Up", function()
		awful.spawn("pactl set-sink-volume @DEFAULT_SINK@ +10%")
	end, { description = "Volume Up", group = "Custom" }),

	awful.key({ mod.super, mod.ctrl }, "Down", function()
		awful.spawn("pactl set-sink-volume @DEFAULT_SINK@ -10%")
	end, { description = "Volume Down", group = "Custom" }),

	awful.key({ mod.super, mod.ctrl }, "Left", function()
		awful.spawn("xbacklight -dec 5")
	end, { description = "Brightness Down", group = "Custom" }),

	awful.key({ mod.super, mod.ctrl }, "Right", function()
		awful.spawn("xbacklight -inc 5")
	end, { description = "Brightness Up", group = "Custom" }),

	awful.key({ mod.super, mod.ctrl, mod.alt }, "Right", function()
		awful.spawn("xrandr --output eDP1 --rotate right")
	end, { description = "Screen rotate right", group = "Custom" }),

	awful.key({ mod.super, mod.ctrl, mod.alt }, "Left", function()
		awful.spawn("xrandr --output eDP1 --rotate left")
	end, { description = "Screen rotate left", group = "Custom" }),

	awful.key({ mod.super, mod.ctrl, mod.alt }, "Up", function()
		awful.spawn("xrandr --output eDP1 --rotate normal")
	end, { description = "Return screen rotation to normal", group = "Custom" }),

	awful.key({ mod.super, mod.ctrl, mod.alt }, "Down", function()
		awful.spawn("xrandr --output eDP1 --rotate inverted")
	end, { description = "Invert screen rotation", group = "Custom" })
)

return globalkeys
