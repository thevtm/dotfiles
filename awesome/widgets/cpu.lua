local beautiful = require("beautiful")
local wibox = require("wibox")
local lain = require("lain")


local M = {}

M.bg_color = "#4B696D"
M.icon = wibox.widget.imagebox(beautiful.widget_cpu)

function M.build()

	local cpu = lain.widget.cpu({
		settings = function()
			widget:set_markup(lain.util.markup.font(beautiful.font, string.format(" %3d%% ", cpu_now.usage)))
		end
	})

	return cpu
end

return M
