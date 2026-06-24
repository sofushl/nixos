vim.lsp.config["json"] = {
	cmd = { "vscode-json-language-server", "--stdio" },
	filetypes = { "json", "jsonc" },
	root_markers = { "package.json", ".git" },
	settings = {
		json = {
			validate = { enable = true },
		},
	},
	init_options = {
		provideFormatter = true,
	},
}
