local beautiful = require("beautiful")


local M = {}

M.bg_color = "#777E76"

function M.build()
	
	-- Binary Clock
	local binclock = require("themes.powerarrow.binclock"){
		height = 16,
		show_seconds = true,
		color_active = beautiful.fg_normal,
		color_inactive = beautiful.bg_focus
	}

	return binclock
end

return M
