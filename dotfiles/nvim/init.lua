-- Keymap
vim.g.mapleader = " "

vim.keymap.set("n", "n", "<cmd>Neotree left toggle<CR>")

vim.keymap.set("n", "gh", vim.diagnostic.open_float)

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

-- clipboard
--vim.opt.clipboard = "unnamed,unnamedplus"

-- LSP remaps
vim.keymap.set("n", "gd", vim.lsp.buf.definition)
vim.keymap.set("n", "gr", vim.lsp.buf.references)
vim.keymap.set("n", "K", vim.lsp.buf.hover)
vim.keymap.set("n", "<leader>rn", vim.lsp.buf.rename)
vim.keymap.set("n", "<leader>ca", vim.lsp.buf.code_action)

-- LSP setup
local lsp_dir = vim.fn.stdpath("config") .. "/lua/lsp"

for _, file in ipairs(vim.fn.readdir(lsp_dir)) do
	if file:match("%.lua$") and file ~= "init.lua" then
		require("lsp." .. file:gsub("%.lua$", ""))
	end
end

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
