local awful = require("awful")
local lain = require("lain")

local config = require('config')


local M = {}

-- Top Quake terminal
M.top = {}

function M.top.build()

	-- Quake terminal application
	local quake = lain.util.quake({
		app = config.terminal,
		name = "QuakeTermTop",
		vert = "top",
		height = 0.3335,
		argname = "--name %s"
	})

	return quake

end

-- Bottom Quake terminal
M.bottom = {}

function M.bottom.build()

	-- Quake terminal application
	local quake = lain.util.quake({
		app = config.terminal,
		name = "QuakeTermBottom",
		vert = "bottom",
		height = 0.3335,
		argname = "--name %s"
	})

	return quake

end

return M
