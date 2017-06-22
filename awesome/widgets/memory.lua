local beautiful = require("beautiful")
local wibox = require("wibox")
local lain = require("lain")


local M = {}

M.bg_color = "#777E76"
M.icon = wibox.widget.imagebox(beautiful.widget_mem)

function M.build()
	
	local mem = lain.widget.mem({
		settings = function()
			if mem_now.swapused >= 32 then
				widget:set_markup(lain.util.markup.font(beautiful.font, string.format(" %3d%% %dM ", mem_now.perc, mem_now.swapused)))
			else
				widget:set_markup(lain.util.markup.font(beautiful.font, string.format(" %3d%% ", mem_now.perc)))
			end
		end
	})

	return mem
end

return M
