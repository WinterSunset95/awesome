local gears = require("gears")
local awful = require("awful")
local wibox = require("wibox")
local naughty = require("naughty")
local beautiful = require("beautiful")

local user = require("user")
local imageicon = require("components.circle_icon")
local log = require("helpers.debugger").log

local icon_font = "Cousine Nerd Font Mono Black "

local function create_line(icon, text, color)
  local widget = wibox.widget({
    {
      {
        font = icon_font .. "20",
        text = icon,
        widget = wibox.widget.textbox,
      },
      widget = wibox.container.background,
      fg = color,
    },
    {
      {
        font = icon_font .. "12",
        text = ": " .. text,
        widget = wibox.widget.textbox,
        id = "text",
      },
      widget = wibox.container.background,
      fg = beautiful.fg_focus,
    },
    layout = wibox.layout.fixed.horizontal,
  })

  return widget
end

local uptime = create_line("", os.date("%Y-%m-%d"), beautiful.fg_highlight3)
local text_container = uptime:get_children_by_id("text")[1]
gears.timer({
  timeout = 60,
  autostart = true,
  call_now = true,
  callback = function()
    awful.spawn.easy_async("uptime -p", function(stdout)
      local parsed = stdout:gsub("up ", "")
      log(parsed)
      parsed = parsed:gsub("\n", "")
      text_container.text = ": " .. parsed
    end)
  end
})

local machine_info = wibox.widget({
	{
		{
      create_line("󰣇", user.host, beautiful.fg_highlight),
      create_line("", "Awesome WM", beautiful.fg_highlight2),
      uptime,
			widget = wibox.container.place,
			layout = wibox.layout.flex.vertical,
		},
		widget = wibox.container.margin,
		margins = DPI(10),
		forced_height = DPI(100),
	},
	widget = wibox.container.background,
	shape = gears.shape.rounded_rect,
	bg = beautiful.bg_focus,
	forced_height = DPI(100),
})

return machine_info
