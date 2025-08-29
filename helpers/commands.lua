local gears = require("gears")
local awful = require("awful")
local wibox = require("wibox")
local naughty = require("naughty")
local beautiful = require("beautiful")
local serialize = require("helpers.serialize")

local function check_command(command)
  local f = io.popen("which " .. command .. "2>/dev/null")
  if f then
    local result = f:read("all")
    f:close()
    return true
  else
    return false
  end
end

return {
  command_exists = check_command
}
