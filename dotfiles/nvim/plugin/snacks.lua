vim.fn.mkdir(vim.fn.stdpath("cache"), "p")

require("snacks").setup({
	bigfile = { enabled = true },
	quickfile = { enabled = true },
	input = { enabled = true },
	picker = { enabled = true },
	explorer = { enabled = true },
	statuscolumn = { enabled = true },
	words = { enabled = true },
	scope = { enabled = true },
	indent = { enabled = true, animate = { enabled = false } },
	notifier = { enabled = true, timeout = 3000 },
	scroll = { enabled = false },
	image = { enabled = true },
	dashboard = {
		enabled = true,
		preset = {
			keys = {
				{ icon = " ", key = "f", desc = "Find File", action = ":lua Snacks.dashboard.pick('files')" },
				{ icon = " ", key = "n", desc = "New File", action = ":ene | startinsert" },
				{ icon = " ", key = "g", desc = "Find Text", action = ":lua Snacks.dashboard.pick('live_grep')" },
				{ icon = " ", key = "r", desc = "Recent Files", action = ":lua Snacks.dashboard.pick('oldfiles')" },
				{ icon = " ", key = "s", desc = "Restore Session", section = "session" },
				{ icon = "󰒲 ", key = "L", desc = "Lazy", action = ":Lazy", enabled = package.loaded.lazy ~= nil },
				{ icon = " ", key = "Q", desc = "Quit", action = ":qa" },
			},
		},
		sections = {
			{ section = "header" },
			{ icon = " ", title = "Recent Files", section = "recent_files", indent = 2, padding = 1 },
			{ icon = " ", title = "Projects", section = "projects", indent = 2, padding = 1 },
			{ section = "keys", gap = 1, padding = 1 },
		},
	},
	terminal = {},
	styles = {
		terminal = {
			position = "right",
			width = 0.4,
			height = 0,
			border = "none",
		},
	},
})
