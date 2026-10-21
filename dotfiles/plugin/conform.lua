require("conform").setup({
	formatters = {
		topcoat = {
			command = "topcoat",
			args = { "fmt", "--stdin" },
		},
	},
	formatters_by_ft = {
		lua = { "stylua" },
		python = { "black", "isort" },
		rust = { "rustfmt", "topcoat" },
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
