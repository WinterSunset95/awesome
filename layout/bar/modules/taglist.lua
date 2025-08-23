local gears = require("gears")
local awful = require("awful")
local wibox = require("wibox")
local naughty = require("naughty")
local beautiful = require("beautiful")
local mod = require("bindings.mod")

-- Create a wibox for each screen and add it
local taglist_buttons = gears.table.join(
	awful.button({}, 1, function(t)
		t:view_only()
	end),
	awful.button({ mod.super }, 1, function(t)
		if client.focus then
			client.focus:move_to_tag(t)
		end
	end),
	awful.button({}, 3, awful.tag.viewtoggle),
	awful.button({ mod.super }, 3, function(t)
		if client.focus then
			client.focus:toggle_tag(t)
		end
	end),
	awful.button({}, 4, function(t)
		awful.tag.viewnext(t.screen)
	end),
	awful.button({}, 5, function(t)
		awful.tag.viewprev(t.screen)
	end)
)

local s = awful.screen.focused()
local screen_geom = s.geometry

local mytaglist = awful.widget.taglist({
	screen = s,
	filter = function(t)
		return #t:clients() > 0
	end,
	layout = {
		layout = wibox.layout.fixed.vertical,
		spacing = 5,
	},
	buttons = taglist_buttons,
	widget_template = {
		{
			{
				id = "icon_role",
				widget = wibox.widget.imagebox,
			},
			id = "bg_container",
			widget = wibox.container.background,
			shape = gears.shape.circle,
			shape_border_width = 2,
			shape_clip = true,
			shape_border_color = "#0f0000",
			forced_height = 40,
			forced_width = 40,
		},
		layout = wibox.layout.flex.vertical,
		create_callback = function(self, t, index, tags)
			self:update_callback(t, index, tags)
		end,
		update_callback = function(self, t, index, tags)
			-- local index_widget = self:get_children_by_id("index_role")[1]
			local icon_widget = self:get_children_by_id("icon_role")[1]
			local background_widget = self:get_children_by_id("bg_container")[1]

			if not icon_widget then
				return
			end

			if t.selected then
				background_widget.shape_border_color = "#ffffff"
				background_widget.shape_border_width = 5
			else
				background_widget.shape_border_color = "#0f0000"
				background_widget.shape_border_width = 5
			end

			local c = t:clients()[1]

			if c and c.icon then
				icon_widget:set_image(c.icon)
			end
		end,
	},
})

return mytaglist
