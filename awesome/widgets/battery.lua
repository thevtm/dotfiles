local beautiful = require("beautiful")
local wibox = require("wibox")
local lain = require("lain")


local M = {}

M.bg_color = "#8DAA9A"
M.icon = wibox.widget.imagebox(beautiful.widget_battery)

function M.build()

	local bat = lain.widget.bat({
		settings = function()
			if bat_now.status ~= "N/A" then
				if bat_now.ac_status == 1 then
					widget:set_markup(lain.util.markup.font(beautiful.font, "  AC "))
					M.icon:set_image(beautiful.widget_ac)
					return
				elseif not bat_now.perc and tonumber(bat_now.perc) <= 5 then
					M.icon:set_image(beautiful.widget_battery_empty)
				elseif not bat_now.perc and tonumber(bat_now.perc) <= 15 then
					M.icon:set_image(beautiful.widget_battery_low)
				else
					M.icon:set_image(beautiful.widget_battery)
				end
				widget:set_markup(lain.util.markup.font(beautiful.font, string.format(" %2d%% ", bat_now.perc)))
			else
				widget:set_markup()
				M.icon:set_image(beautiful.widget_ac)
			end
		end
	})

	return bat
end

return M
