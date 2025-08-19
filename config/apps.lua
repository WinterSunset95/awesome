local user = require("user")

local _M = {
	terminal = user.terminal,
	editor = user.editor,
}

_M.editor_cmd = user.terminal .. " -e " .. user.editor
_M.manual_cmd = user.terminal .. " -e man awesome"

return _M
