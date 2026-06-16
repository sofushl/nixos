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

-- Nix
vim.lsp.config["nil"] = {
	cmd = { "nil" },
	filetypes = { "nix" },
	root_markers = { "flake.nix", ".git" },
}
vim.lsp.enable("nil")

-- Rust
vim.lsp.config["rust_analyzer"] = {
	cmd = { "rust-analyzer" },
	filetypes = { "rust" },
	root_markers = { "Cargo.toml", ".git" },
}
vim.lsp.enable("rust_analyzer")

-- Java
vim.lsp.config["jdtls"] = {
	cmd = { "jdtls" },
	filetypes = { "java" },
	root_markers = { "pom.xml", ".git" },
}
vim.lsp.enable("jdtls")

-- More
local lsp_dir = vim.fn.stdpath("config") .. "/lua/lsp"

for _, file in ipairs(vim.fn.readdir(lsp_dir)) do
	if file:match("%.lua$") and file ~= "init.lua" then
		require("lsp." .. file:gsub("%.lua$", ""))
	end
end

vim.lsp.enable({
	"css",
	"cssmodules",
	"eslint",
	"html",
	"json",
	"lua",
	"markdown",
	"python",
	"tailwind",
	"typescript",
	"yaml",
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
