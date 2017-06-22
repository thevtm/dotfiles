local awful = require("awful")
local beautiful = require("beautiful")
local lain = require("lain")


local M = {}

M.bg_color = "#C0C0A2"

function M.build()

	local volume = lain.widget.alsabar({
			ticks = true, width = 67,
			notification_preset = { font = beautiful.font },
			colors = {
				background = "#000000",
				mute       = "#707070",
				unmute     = "#FFFFFF"
			}
	})

	volume.tooltip.wibox.fg = beautiful.fg_focus
	volume.tooltip.wibox.font = beautiful.font
	volume.bar:buttons(awful.util.table.join (
		awful.button({}, 1, function()
			awful.spawn.with_shell(string.format("%s -e alsamixer", terminal))
		end),
		awful.button({}, 2, function()
			awful.spawn(string.format("%s set %s 100%%", volume.cmd, volume.channel))
			volume.update()
		end),
		awful.button({}, 3, function()
			awful.spawn(string.format("%s set %s toggle", volume.cmd, volume.togglechannel or volume.channel))
			volume.update()
		end),
		awful.button({}, 4, function()
			awful.spawn(string.format("%s set %s 1%%+", volume.cmd, volume.channel))
			volume.update()
		end),
		awful.button({}, 5, function()
			awful.spawn(string.format("%s set %s 1%%-", volume.cmd, volume.channel))
			volume.update()
		end)
	))

	return volume
end

return M
