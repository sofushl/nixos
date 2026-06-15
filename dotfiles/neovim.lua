-- Keymap
vim.g.mapleader = " "

vim.keymap.set("n", "n", "<cmd>Neotree left toggle<CR>")

vim.keymap.set("n", "T", "<cmd>tabclose<cr>")
vim.keymap.set("n", "t", "<cmd>tabnew<cr>")

-- remap for norwegian keyboard
vim.keymap.set("n", "å", "[")
vim.keymap.set("n", "¨", "]")

vim.keymap.set("n", "Å", "{")
vim.keymap.set("n", "^", "}")

vim.keymap.set("n", "¤", "$")
vim.keymap.set("n", "&", "^")

vim.keymap.set("v", "¤", "$")
vim.keymap.set("v", "&", "^")

-- LSP remaps
vim.keymap.set("n", "gd", vim.lsp.buf.definition)
vim.keymap.set("n", "gr", vim.lsp.buf.references)
vim.keymap.set("n", "K", vim.lsp.buf.hover)
vim.keymap.set("n", "<leader>rn", vim.lsp.buf.rename)
vim.keymap.set("n", "<leader>ca", vim.lsp.buf.code_action)

-- Python
vim.lsp.config["pyright"] = {
	cmd = { "pyright-langserver", "--stdio" },
	filetypes = { "python" },
	root_markers = { ".git", "pyproject.toml", "requirements.txt" },
}
vim.lsp.enable("pyright")

-- Lua
vim.lsp.config["lua_ls"] = {
	cmd = { "lua-language-server" },
	filetypes = { "lua" },
	root_markers = { ".git", ".luarc.json", ".luarc.jsonc" },
	settings = {
		Lua = {
			runtime = { version = "LuaJIT" },
			diagnostics = { globals = { "vim" } },
		},
	},
}
vim.lsp.enable("lua_ls")

-- Nix
vim.lsp.config["nil_ls"] = {
	cmd = { "nil" },
	filetypes = { "nix" },
	root_markers = { "flake.nix", ".git" },
}
vim.lsp.enable("nil_ls")

-- Rust
vim.lsp.config["rust_analyzer"] = {
	cmd = { "rust-analyzer" },
	filetypes = { "rust" },
	root_markers = { "Cargo.toml", ".git" },
}
vim.lsp.enable("rust_analyzer")

-- Typescript
vim.lsp.config["ts_ls"] = {
	filetypes = { "typescript", "typescriptreact", "typescript.tsx", "javascript", "javascript.jsx" },
	root_markers = { "tsconfig.json", ".git", "index.html", "package.json" },
	cmd = { "typescript-language-server", "--stdio" },
}
vim.lsp.enable("ts_ls")

-- Java
vim.lsp.config["jdtls"] = {
	cmd = { "jdtls" },
	filetypes = { "java" },
	root_markers = { "pom.xml", ".git" },
}
vim.lsp.enable("jdtls")

-- More
vim.lsp.enable({
	"ts_ls",
	"eslint",
	"html",
	"cssls",
	"jdt-language-server",
	"jsonls",
	"tailwindcss",
	"lua_ls",
	"nil_ls",
	"bashls",
	"pyright",
	"rust_analyzer",
	"gopls",
	"yamlls",
})

-- Completion
require("blink.cmp").setup({
	completion = {
		menu = {
			auto_show = true,
		},
	},

	keymap = {
		["<C-j>"] = { "select_next", "fallback" },
		["<C-k>"] = { "select_prev", "fallback" },
		["<C-l>"] = { "accept", "fallback" },
		["<tab>"] = { "accept", "fallback" },
	},
})

-- Formatting
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
		timeout_ms = 500,
		lsp_format = "fallback",
	},
})

-- Formatting option
vim.opt.tabstop = 2
vim.opt.shiftwidth = 2
vim.opt.softtabstop = 2
vim.opt.expandtab = true
vim.opt.smartindent = true
