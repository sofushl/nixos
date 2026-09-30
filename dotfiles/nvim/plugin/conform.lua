require("conform").setup({
	formatters_by_ft = {
		lua = { "stylua" },
		python = { "black", "isort" },
		rust = { "rustfmt" },
		javascript = { "prettierd" },
		typescript = { "prettierd" },
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
