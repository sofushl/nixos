vim.g.mapleader = " "
vim.g.maplocalleader = " "

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
vim.opt.number = true
vim.opt.relativenumber = true
