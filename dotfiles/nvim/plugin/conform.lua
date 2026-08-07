require("conform").setup({
	formatters_by_ft = {
		lua = { "stylua" },
		python = { "isort", "black" },
		rust = { "rustfmt" },
		javascript = { "prettierd", "prettier" },
		typescript = { "prettierd", "prettier" },
		nix = { "nixfmt" },
		kdl = { "kdlfmt" },
		java = { "google-java-format" },
	},
	format_on_save = {
		timeout_ms = 1000,
		lsp_format = "first",
	},
})
