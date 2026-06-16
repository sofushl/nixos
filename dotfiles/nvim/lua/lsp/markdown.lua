vim.lsp.config["markdown"] = {
	cmd = { "vscode-markdown-language-server", "server" },
	filetypes = { "markdown", "markdown.mdx" },
	root_markers = { ".marksman.toml", ".git" },
}
