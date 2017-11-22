local beautiful = require("beautiful")
local lain = require("lain")

local M = {}

function M.build(clock)

	local calendar = lain.widget.calendar({
		--cal = "cal --color=always",
		attach_to = { clock },
		notification_preset = {
			font = "xos4 Terminus 10",
			fg   = beautiful.fg_normal,
			bg   = beautiful.bg_normal
		}
	})

	return calendar
end

return M
