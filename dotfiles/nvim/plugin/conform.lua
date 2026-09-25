require("conform").setup({
	formatters_by_ft = {
		lua = { "stylua" },
		python = { "isort", "black" },
		rust = { "rustfmt" },
		javascript = { "prettierd", "prettier", stop_after_first = true },
		typescript = { "prettierd", "prettier", stop_after_first = true },
		nix = { "nixfmt" },
		kdl = { "kdlfmt" },
		yaml = { "yamlfmt" },
		java = { "google-java-format" },
		typst = { "typstyle" },
	},
	format_on_save = {
		timeout_ms = 1000,
		lsp_format = "first",
	},
})
