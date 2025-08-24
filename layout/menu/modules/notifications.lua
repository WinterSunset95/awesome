local gears = require("gears")
local awful = require("awful")
local wibox = require("wibox")
local naughty = require("naughty")
local beautiful = require("beautiful")
local log = require("helpers.debugger").log

local notif_history = {}
local notif_index = #notif_history
local function get_slice(tbl, start, length)
	local result = {}
	local len = #tbl
	if len <= length then
		return tbl
	end
	if start > len - (length - 1) then
		start = len - (length - 1)
	end
	for i = start, math.min(start + (length - 1), len) do
		table.insert(result, tbl[i])
	end
	return result
end

local function generate_notification_item(args)
	local notification_item = wibox.widget({
		{
			{
				{
					{
						{
							{
								{
									font = "Cousine Nerd Font Mono Black 12",
									text = args.title,
									widget = wibox.widget.textbox,
								},
								step_function = wibox.container.scroll.step_functions.linear_back_and_forth,
								layout = wibox.layout.scroll.horizontal,
							},
							widget = wibox.container.constraint,
							width = 300,
						},
						{
							{
								{
									font = "Cousine Nerd Font Mono Black 12",
									text = args.text,
									widget = wibox.widget.textbox,
								},
								step_function = wibox.container.scroll.step_functions.linear_back_and_forth,
								layout = wibox.layout.scroll.horizontal,
							},
							widget = wibox.container.constraint,
							width = 300,
						},
						spacing = 5,
						layout = wibox.layout.fixed.vertical,
					},
					widget = wibox.container.place,
				},
				{
					widget = wibox.widget.separator,
					forced_height = 2,
					shape = gears.shape.rounded_bar,
					color = beautiful.fg_normal,
					visible = false,
				},
				{
					{
						image = args.icon,
						widget = wibox.widget.imagebox,
						forced_height = 60,
						forced_width = 60,
					},
					widget = wibox.container.background,
					shape = gears.shape.rounded_rect,
					shape_clip = true,
					forced_width = 60,
					forced_height = 60,
				},
				layout = wibox.layout.align.horizontal,
			},
			widget = wibox.container.margin,
			margins = 10,
		},
		widget = wibox.container.background,
		bg = beautiful.bg_normal,
		shape = gears.shape.rounded_rect,
		buttons = gears.table.join(awful.button({}, 1, function()
			-- naughty.destroy(args)
			naughty.notify({
				title = "Test Notification",
				text = "This is a test notification",
				icon = "/home/autumn/Desktop/Arch-Dotfiles/awesome/themes/custom/layouts/tile.png",
			})
		end)),
	})
	return notification_item
end

local notification_list = wibox.widget({
	widget = wibox.layout.fixed.vertical,
	spacing = 10,
	buttons = gears.table.join(
		awful.button({}, 4, function()
			awesome.emit_signal("notification::scroll_up")
		end),
		awful.button({}, 5, function()
			awesome.emit_signal("notification::scroll_down")
		end)
	),
})

local function draw_notification(args)
	table.insert(notif_history, args)
	notif_index = #notif_history
	notification_list:reset()
	local to_show = get_slice(notif_history, notif_index, 6)
	for _, new_args in pairs(to_show) do
		local new_notif = generate_notification_item(new_args)
		notification_list:add(new_notif)
	end
end

naughty.config.notify_callback = function(args)
	draw_notification(args)
	return args
end

awesome.connect_signal("notification::scroll_up", function()
	if notif_index > 1 then
		notif_index = notif_index - 1
		notification_list:reset()
		local to_show = get_slice(notif_history, notif_index, 6)
		for _, new_args in pairs(to_show) do
			local new_notif = generate_notification_item(new_args)
			notification_list:add(new_notif)
		end
	end
end)

awesome.connect_signal("notification::scroll_down", function()
	if notif_index < #notif_history then
		notif_index = notif_index + 1
		notification_list:reset()
		local to_show = get_slice(notif_history, notif_index, 6)
		for _, new_args in pairs(to_show) do
			local new_notif = generate_notification_item(new_args)
			notification_list:add(new_notif)
		end
	end
end)

local title = wibox.widget({
	{
		font = "Cousine Nerd Font Mono Black 12",
		text = "Notifications",
		widget = wibox.widget.textbox,
		align = "center",
	},
	{
		widget = wibox.widget.separator,
		forced_height = 2,
		shape = gears.shape.rounded_bar,
		color = beautiful.fg_normal,
		visible = false,
	},
	{
		{
			font = "Cousine Nerd Font Mono Black 20",
			text = "󰎟",
			widget = wibox.widget.textbox,
			align = "center",
		},
		widget = wibox.container.background,
		forced_width = 30,
		forced_height = 30,
		bg = beautiful.bg_normal,
		shape = gears.shape.circle,
		clip = true,
	},
	widget = wibox.layout.align.horizontal,
})

local notifications = wibox.widget({
	{
		{
			title,
			notification_list,
			layout = wibox.layout.fixed.vertical,
			spacing = 10,
		},
		widget = wibox.container.margin,
		margins = 10,
	},
	widget = wibox.container.background,
	bg = beautiful.bg_focus,
	shape = gears.shape.rounded_rect,
})

-- awesome.connect_signal("property::notification", function(n)
-- 	log(n)
-- end)

return notifications
