local awful = require("awful")
local screen = awful.screen.focused()

local menu = {
	menu_width = DPI(450),
	menu_height = screen.geometry.height,
}

return menu
