local gears = require("gears")
local awful = require("awful")


local M = {}

function M.build(screen)

	-- Create an imagebox widget which will contains an icon indicating which layout we're using.
	local layoutbox = awful.widget.layoutbox(screen)
	layoutbox:buttons(gears.table.join(
		awful.button({ }, 1, function () awful.layout.inc( 1) end),
		awful.button({ }, 3, function () awful.layout.inc(-1) end),
		awful.button({ }, 4, function () awful.layout.inc( 1) end),
		awful.button({ }, 5, function () awful.layout.inc(-1) end)
	))

	return layoutbox
end

return M
