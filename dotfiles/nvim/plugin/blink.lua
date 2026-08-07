require("blink.cmp").setup({
	fuzzy = { implementation = "rust" },
	completion = {
		menu = { auto_show = true },
		list = { max_items = 50 },
		trigger = { prefetch_on_insert = false },
	},

	sources = {
		per_filetype = { opencode_ask = { "lsp", "buffer" } },
		providers = { lsp = { fallbacks = {} } },
	},

	keymap = {
		["<C-j>"] = { "select_next", "fallback" },
		["<C-k>"] = { "select_prev", "fallback" },
		["<C-l>"] = { "accept", "fallback" },
		["<tab>"] = { "accept", "fallback" },
	},
})
