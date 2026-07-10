vim.lsp.config["python"] = {
	cmd = { "pyright-langserver", "--stdio" },
	filetypes = { "python" },
	root_markers = { ".git", "pyproject.toml", "requirements.txt", "pyrightconfig.json" },
}

vim.lsp.config["markdown"] = {
	cmd = { "vscode-markdown-language-server", "--stdio" },
	filetypes = { "markdown" },
	root_markers = { ".marksman.toml", ".git" },
}

vim.lsp.config["yaml"] = {
	cmd = { "yaml-language-server", "--stdio" },
	filetypes = { "yaml" },
	root_markers = { ".git" },
	settings = {
		redhat = { telemetry = { enabled = false } },
	},
}

vim.lsp.config["nix"] = {
	cmd = { "nil" },
	filetypes = { "nix" },
	root_markers = { "flake.nix", ".git" },
}

vim.lsp.config["rust"] = {
	cmd = { "rust-analyzer" },
	filetypes = { "rust" },
	root_markers = { "Cargo.toml", ".git" },
}

vim.lsp.config["java"] = {
	cmd = { "jdtls" },
	filetypes = { "java" },
	root_markers = { "pom.xml", ".git" },
}
