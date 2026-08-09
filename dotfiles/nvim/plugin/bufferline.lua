vim.opt.termguicolors = true
require("bufferline").setup({
	options = {
		mode = "buffers",
		diagnostics = "nvim_lsp",
		always_show_bufferline = true,
		offsets = { { filetype = "snacks_layout_box" } },
	},
})

local map = vim.keymap.set
-- buffers
map("n", "<S-h>", "<Cmd>BufferLineCyclePrev<CR>")
map("n", "<S-l>", "<Cmd>BufferLineCycleNext<CR>")

-- displaced defaults: S-k -> top of window, S-j -> bottom
map({ "n", "x" }, "<S-k>", "H")
map({ "n", "x" }, "<S-j>", "L")
