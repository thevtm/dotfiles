local gears = require("gears")
local awful = require("awful")


local M = {}

function M.build(screen)

	local buttons = gears.table.join(

		awful.button({ }, 1, function (c)
			if c == client.focus then
				c.minimized = true
			else
				-- Without this, the following
				-- :isvisible() makes no sense
				c.minimized = false
				if not c:isvisible() and c.first_tag then
					c.first_tag:view_only()
				end
				-- This will also un-minimize
				-- the client, if needed
				client.focus = c
				c:raise()
			end
		end),

		awful.button({ }, 3, function()
			local instance = nil

			return function ()
				if instance and instance.wibox.visible then
					instance:hide()
					instance = nil
				else
					instance = awful.menu.clients({ theme = { width = 250 } })
				end
			end
		end),

		awful.button({ }, 4, function ()
			awful.client.focus.byidx(1)
		end),

		awful.button({ }, 5, function ()
			awful.client.focus.byidx(-1)
		end)
	)

	local tasklist = awful.widget.tasklist(screen, awful.widget.tasklist.filter.currenttags, buttons)

	return tasklist
end

return M
