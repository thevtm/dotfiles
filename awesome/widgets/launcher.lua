local awful = require("awful")
local beautiful = require("beautiful")


local M = {}

function M.build(awesome_menu)
	
	local launcher = awful.widget.launcher({
		image = beautiful.menu_submenu_icon,
		menu = awesome_menu
	})

	return launcher
end

return M
