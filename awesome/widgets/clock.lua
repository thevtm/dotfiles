local beautiful = require("beautiful")
local wibox = require("wibox")
local markup = require("lain").util.markup


os.setlocale(os.getenv("LANG")) -- to localize the clock

local M = {}

M.bg_color = "#777E76"

function M.build()

	-- Text Clock
	local textclock = wibox.widget.textclock(markup(beautiful.fg_normal, "%H:%M"))
	textclock.font = beautiful.font

	return textclock

end

return M
