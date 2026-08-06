return {
	cmd = { "rust-analyzer" },
	filetypes = { "rust" },
	root_markers = { { "Cargo.lock", "rust-project.json" }, "Cargo.toml", ".git" },
	settings = {
		["rust-analyzer"] = {
			cachePriming = { enable = false },
			cargo = {
				buildScripts = { enable = true, invocationStrategy = "once" },
			},
			check = { command = "clippy", workspace = false },
			files = { excludeDirs = { ".direnv", ".git", "target", "node_modules", "result" } },
			lru = { capacity = 512 },
			diagnostics = { experimental = { enable = false } },
		},
	},
}
