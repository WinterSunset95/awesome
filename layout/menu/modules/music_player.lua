local gears = require("gears")
local awful = require("awful")
local wibox = require("wibox")
local naughty = require("naughty")
local beautiful = require("beautiful")
local log = require("helpers.debugger").log
local slider_small = require("components.slider_small")
local create_separator = require("components.separator")
local circle_icon = require("components.circle_icon")

local slider_obj = slider_small()
local track_slider = slider_obj.slider
local controller = slider_obj.controller
local displayer = slider_obj.displayer

local playing = false
local curr_time = 0

local current_position = wibox.widget({
	text = "00:00",
	font = "Cousine Nerd Font Mono Black 10",
	valign = "center",
	halign = "center",
	widget = wibox.widget.textbox,
})
local full_length = wibox.widget({
	text = "00:00",
	font = "Cousine Nerd Font Mono Black 10",
	valign = "center",
	halign = "center",
	widget = wibox.widget.textbox,
})
gears.timer({
	timeout = 1,
	call_now = true,
	autostart = true,
	callback = function()
		if playing then
			--log(curr_time)
			displayer.value = curr_time
			local minutes = math.floor(curr_time / 60)
			local seconds = math.floor(curr_time % 60)
			current_position.text = string.format("%02d:%02d", minutes, seconds)
			curr_time = curr_time + 1
		end
	end,
})

local buffer = true
gears.timer({
	timeout = 1,
	call_now = true,
	autostart = true,
	callback = function()
		buffer = false
	end,
})

controller:connect_signal("property::value", function(params)
	--log(params.value)
	displayer.value = params.value
	if buffer == true then
		return
	end
	awful.spawn.easy_async_with_shell("playerctl position " .. params.value, function(stdout) end)
	displayer.value = params.value
	buffer = true
end)

local timestamps = wibox.widget({
	current_position,
	nil,
	full_length,
	layout = wibox.layout.align.horizontal,
})

local play = circle_icon.create_text_icon("", "#f0900f", 50, 50, "music::toggle")
local next = circle_icon.create_text_icon("󰒭", nil, 40, 40, "music::next")
local prev = circle_icon.create_text_icon("󰒮", nil, 40, 40, "music::prev")
local seek_forward = circle_icon.create_text_icon("", nil, 30, 30, "music::seek_forward")
local seek_backward = circle_icon.create_text_icon("", nil, 30, 30, "music::seek_backward")
local controls = wibox.widget({
	seek_backward,
	prev,
	play,
	next,
	seek_forward,
	layout = wibox.layout.flex.horizontal,
	spacing = 10,
})

local player = wibox.widget({
	{
		{
			{
				id = "role_image",
				image = "/tmp/spotify_cover.jpg",
				widget = wibox.widget.imagebox,
			},
			widget = wibox.container.background,
			bg = beautiful.bg_focus,
			shape = gears.shape.rounded_rect,
			shape_clip = true,
		},
		create_separator(10),
		{
			{
				id = "role_title",
				font = "Cousine Nerd Font Mono Black 30",
				text = "No songs playing",
				widget = wibox.widget.textbox,
				valign = "bottom",
			},
			widget = wibox.container.scroll.horizontal,
			step_function = wibox.container.scroll.step_functions.linear_back_and_forth,
		},
		{
			{
				id = "role_artist",
				text = "No songs playing",
				widget = wibox.widget.textbox,
				valign = "top",
				font = "Cousine Nerd Font Mono Black 12",
			},
			widget = wibox.container.scroll.horizontal,
			step_function = wibox.container.scroll.step_functions.linear_back_and_forth,
		},
		create_separator(10),
		track_slider,
		create_separator(5),
		timestamps,
		controls,
		layout = wibox.layout.fixed.vertical,
	},
	widget = wibox.container.margin,
	margins = 10,
})

awesome.connect_signal("music::toggle", function()
	awful.spawn.with_shell("playerctl play-pause")
end)
awesome.connect_signal("music::next", function()
	awful.spawn.with_shell("playerctl next")
end)
awesome.connect_signal("music::prev", function()
	awful.spawn.with_shell("playerctl previous")
end)
awesome.connect_signal("music::seek_forward", function()
	awful.spawn.with_shell("playerctl position +" .. tostring(10))
end)
awesome.connect_signal("music::seek_backward", function()
	awful.spawn.with_shell("playerctl position -" .. tostring(5))
end)

awesome.connect_signal("music::update", function(status)
	awful.spawn.easy_async_with_shell("playerctl position", function(line)
		if line == "" or line == nil then
			return
		end
		curr_time = tonumber(line) or 0
	end)
	local minutes = math.floor(status.length / 60)
	local seconds = math.floor(status.length % 60)
	full_length.text = string.format("%02d:%02d", minutes, seconds)
	local image = player:get_children_by_id("role_image")[1]
	local title = player:get_children_by_id("role_title")[1]
	local artist = player:get_children_by_id("role_artist")[1]
	image.image = status.artUrl
	title.text = status.title
	artist.text = status.artist
	controller.maximum = status.length
	displayer.max_value = status.length
	playing = status.playing
	if playing == false then
		play:get_children_by_id("role_text")[1].text = ""
	else
		play:get_children_by_id("role_text")[1].text = ""
	end
end)

local container = wibox.widget({
	player,
	widget = wibox.container.background,
	bg = beautiful.bg_focus,
	fg = beautiful.fg_focus,
	shape = gears.shape.rounded_rect,
})

return container
