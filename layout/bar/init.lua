local gears = require("gears")
local awful = require("awful")
local wibox = require("wibox")
local naughty = require("naughty")
local beautiful = require("beautiful")
local mytaglist = require("layout.bar.modules.taglist")

local mytextclock = require("layout.bar.modules.clock")
local systray = require("layout.bar.modules.systray")
local battery = require("layout.bar.modules.battery")
local background_container = require("layout.bar.modules.background_container")
local serialize = require("helpers.serialize")
local animate = require("helpers.animate")

local mod = require("bindings.mod")
local menu_configs = require("config.menu")
local icon_font = "Cousine Nerd Font Mono Black 30"
local user = require("user")

awful.screen.connect_for_each_screen(function(s)
	-- Create a taglist widget
	s.mytaglist = mytaglist

	-- Create the wibox
	s.mywibox = awful.wibar({
		ontop = true,
		position = "left",
		screen = s,
		width = DPI(60),
	})

	local animating = false
	awesome.connect_signal("toggle::menu", function()
		if animating == true then
			return
		end
		animating = true
		if s.mywibox.x == 0 then
			animate(0.1, 60, s.mywibox.x, menu_configs.menu_width, "", function(pos)
				s.mywibox.x = DPI(pos)
				if user.bar_floating == false then
					s.mywibox:struts({ left = DPI(pos + 60), right = 0, bottom = 0, top = 0 })
				end
			end)
		else
			animate(0.1, 60, s.mywibox.x, 0, "", function(pos)
				s.mywibox.x = DPI(pos)
				if user.bar_floating == false then
					s.mywibox:struts({ left = DPI(pos + 60), right = 0, bottom = 0, top = 0 })
				end
			end)
		end
		animating = false
	end)

	local function toggleMenu()
		awesome.emit_signal("toggle::menu")
	end

	-- Add widgets to the wibox
	s.mywibox:setup({
		layout = wibox.layout.margin,
		margins = DPI(5),
		bg = beautiful.bg_normal,
		{
			layout = wibox.layout.align.vertical,
			{
				{
					{
						font = icon_font,
						text = "󱗼",
						align = "center",
						widget = wibox.widget.textbox,
					},
					widget = wibox.container.background,
					bg = beautiful.bg_focus,
					shape = gears.shape.rounded_rect,
					buttons = gears.table.join(awful.button({}, 1, function()
						toggleMenu()
					end)),
				},
				mytextclock,
				layout = wibox.layout.fixed.vertical,
				spacing = DPI(5),
			},
			{
				{
					{
						s.mytaglist,
						widget = wibox.container.margin,
						margins = DPI(5),
					},
					widget = wibox.container.background,
					shape = gears.shape.rounded_rect,
					bg = beautiful.bg_focus,
					forced_width = DPI(50),
				},
				widget = wibox.container.place,
			},
			{
				background_container(battery, 5, "battery_container"),
				widget = wibox.layout.align.vertical,
			},
		},
	})
end)
