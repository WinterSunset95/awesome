local gears = require("gears")
local awful = require("awful")
local wibox = require("wibox")
local naughty = require("naughty")
local beautiful = require("beautiful")
local animate = require("helpers.animate")

local function create_image_icon(path, color, height, width, signal)
	local icon = wibox.widget({
    {
      {
        image = path,
        widget = wibox.widget.imagebox,
        id = "role_image",
      },
      widget = wibox.container.place,
      forced_height = height or nil,
      forced_width = width or nil,
		},
		widget = wibox.container.background,
		shape_clip = true,
		bg = color or beautiful.bg_focus,
		shape = gears.shape.circle,
		forced_height = height or nil,
		forced_width = width or nil,
		buttons = gears.table.join(awful.button({}, 1, function()
			awesome.emit_signal(signal)
		end)),
	})
	return icon
end

local function create_text_icon(icon, color, height, width, signal)
	local imageicon = wibox.widget({
		{
			text = icon,
			font = "Cousine Nerd Font Mono Black 15",
			align = "center",
			widget = wibox.widget.textbox,
			id = "role_text",
		},
		widget = wibox.container.background,
		shape_clip = true,
		bg = color or beautiful.fg_normal,
		forced_height = height or nil,
		forced_width = width or nil,
		shape = gears.shape.circle,
		buttons = gears.table.join(awful.button({}, 1, function()
			awesome.emit_signal(signal)
		end)),
	})
	return imageicon
end

return {
	create_image_icon = create_image_icon,
	create_text_icon = create_text_icon,
}
