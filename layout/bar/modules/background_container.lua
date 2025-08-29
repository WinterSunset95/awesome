local gears = require("gears")
local awful = require("awful")
local wibox = require("wibox")
local naughty = require("naughty")
local beautiful = require("beautiful")

local function build(widget, margin, id)
  local mywidget = widget
  if not widget or not margin or not id then
    mywidget = wibox.widget({
      text = "0",
      font = "Cousine Nerd Font 15",
      align = "center",
      widget = wibox.widget.textbox,
    })
  end

	local container = wibox.widget({
		{
			mywidget,
			widget = wibox.container.margin,
			margins = margin,
		},
		id = id,
		widget = wibox.container.background,
		bg = beautiful.bg_focus,
		shape = gears.shape.rounded_rect,
	})
	return container
end

return build
