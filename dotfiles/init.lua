vim.g.mapleader = " "
vim.g.maplocalleader = " "

-- LSP enabling
vim.lsp.enable({
	"python",
	"asm",
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
	"c",
	"tinymist",
})

-- Formatting option
vim.opt.tabstop = 4
vim.opt.shiftwidth = 4
vim.opt.softtabstop = 4
vim.opt.expandtab = true
vim.opt.smartindent = true

vim.api.nvim_create_autocmd("FileType", {
	pattern = "java",
	callback = function()
		vim.bo.tabstop = 2
		vim.bo.shiftwidth = 2
		vim.bo.softtabstop = 2
	end,
})

vim.cmd.colorscheme("vscode")
vim.opt.number = true
vim.opt.relativenumber = true
