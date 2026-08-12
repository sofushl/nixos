vim.opt.termguicolors = true
require("bufferline").setup({
	options = {
		mode = "buffers",
		diagnostics = "nvim_lsp",
		always_show_bufferline = true,
		offsets = { { filetype = "snacks_layout_box" } },
	},
})
