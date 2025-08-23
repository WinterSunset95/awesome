local gears = require("gears")
local awful = require("awful")
local wibox = require("wibox")
local naughty = require("naughty")
local beautiful = require("beautiful")
local serialize = require("helpers.serialize")

-- test
-- 0.25 * 30 = 7.5
-- 0.25 / 7.5 = 0.033333333333
--
-- 0.25 * 1 = 0.25
-- 0.25/0.25 = 1

local function animate(duration, fps, from, to, easing, subscribe)
	local current_frame = 0
	local current_target = from
	local total_frames = duration * fps
	local frame_duration = duration / total_frames
	local change_per_frame = (to - from) / total_frames
	local timer = gears.timer({
		timeout = frame_duration,
		autostart = true,
		callback = function(t)
			current_frame = current_frame + 1
			current_target = current_target + change_per_frame
			if current_frame >= total_frames then
				t:stop()
			end
			subscribe(current_target)
		end,
	})
	return timer
end

return animate
