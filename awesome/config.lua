local os = require("os")

return {
	chosen_theme = "powerarrow",

	tag_names = { "1", "2", "3", "4", "5" },

	modkey       = "Mod4",
	altkey       = "Mod1",

	terminal     = "termite",
	editor       = os.getenv("EDITOR") or "vim",
	gui_editor   = "gvim",
	browser      = "google-chrome-stable"
}
