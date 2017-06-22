local os = require("os")

return {
	chosen_theme = "powerarrow",

	modkey       = "Mod4",
	altkey       = "Mod1",

	foo = "foo",
	
	terminal     = "termite",
	editor       = os.getenv("EDITOR") or "vim",
	gui_editor   = "gvim",
	browser      = "google-chrome-stable"
}
