-- Keymap
vim.g.mapleader = " "

vim.keymap.set("n", "q", "<cmd>Yazi<CR>")
vim.keymap.set("v", "q", "<cmd>Yazi<CR>")

vim.keymap.set("n", "T", "<cmd>tabclose<cr>")
vim.keymap.set("n", "t", "<cmd>tabnew<cr>")

vim.keymap.set("n", "gk", "<cmd>tabnext<cr>")
vim.keymap.set("n", "gj", "<cmd>tabprevious<cr>")

vim.keymap.set("n", "gh", vim.diagnostic.open_float)
vim.keymap.set("n", "gs", vim.lsp.buf.hover)
vim.keymap.set("n", "gd", vim.lsp.buf.definition)

-- remap for norwegian keyboard
vim.keymap.set("n", "å", "[")
vim.keymap.set("n", "¨", "]")

vim.keymap.set("n", "Å", "{")
vim.keymap.set("n", "^", "}")

vim.keymap.set("n", "¤", "$")
vim.keymap.set("n", "&", "^")

vim.keymap.set("v", "¤", "$")
vim.keymap.set("v", "&", "^")
-- LSP setup
vim.lsp.enable({
	"python",
	"nix",
	"rust",
	"java",
	"css",
	"eslint",
	"html",
	"json",
	"lua",
	"markdown",
	"tailwind",
	"typescript",
	"yaml",
})

-- Completion
require("blink.cmp").setup({
	fuzzy = { implementation = "rust" },
	completion = {
		menu = { auto_show = true },
		list = { max_items = 50 },
		trigger = { prefetch_on_insert = false },
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
		timeout_ms = 1000,
		lsp_format = "first",
	},
})

-- Formatting option
vim.opt.tabstop = 4
vim.opt.shiftwidth = 4
vim.opt.softtabstop = 4
vim.opt.expandtab = true
vim.opt.smartindent = true
