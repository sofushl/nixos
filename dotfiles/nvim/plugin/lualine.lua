require("lualine").setup({
	options = { theme = "auto", globalstatus = true, section_separators = "", component_separators = "" },
	sections = {
		lualine_c = { "filename", "lsp_progress" },
	},
})
