local awful = require("awful")

awful.spawn("picom --daemon")
awful.spawn("nm-applet")
-- awful.spawn("feh --bg-fill /home/autumn/.config/i3/wallpapers/hayati.jpeg")
