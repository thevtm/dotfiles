local awful = require("awful")
local beautiful = require("beautiful")
local freedesktop   = require("freedesktop")
local hotkeys_popup = require("awful.hotkeys_popup").widget

local config = require("config")


local M = {}

function M.build(awesome)
	
	local myawesomemenu = {
		{ "hotkeys", function() return false, hotkeys_popup.show_help end },
		{ "manual", config.terminal .. " -e man awesome" },
		{ "edit config", string.format("%s -e %s %s", config.terminal, config.editor, awesome.conffile) },
		{ "restart awesome", awesome.restart },
		{ "logout", function() awesome.quit() end },
		{ "reboot", "systemctl reboot" },
		{ "shutdown", "systemctl poweroff"}
	}

	myawesomemenu = freedesktop.menu.build({
		icon_size = beautiful.menu_height or 16,
		before = {
			{ "Awesome", myawesomemenu, beautiful.awesome_icon },
			-- other triads can be put here
		},
		after = {
			{ "Open terminal", config.terminal },
			-- other triads can be put here
		}
	})

	return myawesomemenu
end

return M
