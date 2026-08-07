-- Keymap
vim.g.mapleader = " "

vim.keymap.set({ "n", "v" }, "q", "<cmd>Yazi<CR>")

vim.keymap.set({ "n", "v" }, "Q", ":qa")

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
