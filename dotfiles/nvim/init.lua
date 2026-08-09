-- Keymap
vim.g.mapleader = " "

local map = vim.keymap.set

map({ "n", "v" }, "q", "<cmd>Yazi<CR>")

map({ "n", "v" }, "Q", "<cmd>qa<CR>")

map("n", "gh", vim.diagnostic.open_float)
map("n", "gs", vim.lsp.buf.hover)
map("n", "gd", vim.lsp.buf.definition)

map({ "n", "v", "x" }, "<C-n>", "<cmd>vsplit<CR>")
map({ "n", "v", "x" }, "<C-m>", "<cmd>split<CR>")

-- remap for norwegian keyboard
map({ "n", "v" }, "å", "[")
map({ "n", "v" }, "¨", "]")

map({ "n", "v" }, "Å", "{")
map({ "n", "v" }, "^", "}")

map({ "n", "v" }, "¤", "$")
map({ "n", "v" }, "&", "^")

-- LSP enabling
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

-- Formatting option
vim.opt.tabstop = 4
vim.opt.shiftwidth = 4
vim.opt.softtabstop = 4
vim.opt.expandtab = true
vim.opt.smartindent = true

vim.cmd.colorscheme("vscode")
