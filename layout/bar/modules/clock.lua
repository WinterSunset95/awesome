local gears = require("gears")
local wibox = require("wibox")
local beautiful = require("beautiful")

local mytextclock = {
	{
		{
			format = "%H\n%M",
			align = "center",
			font = "Cousine Nerd Font Mono Black 16",
			widget = wibox.widget.textclock,
		},
		widget = wibox.container.margin,
		margins = 5,
	},
	widget = wibox.container.background,
	bg = beautiful.bg_focus,
	shape = gears.shape.rounded_rect,
}

return mytextclock
