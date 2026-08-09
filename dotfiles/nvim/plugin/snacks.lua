vim.fn.mkdir(vim.fn.stdpath("cache"), "p")

require("snacks").setup({
	bigfile = { enabled = true },
	quickfile = { enabled = true },
	input = { enabled = true },
	picker = { enabled = true },
	explorer = { enabled = true },
	statuscolumn = { enabled = true },
	words = { enabled = true },
	scope = { enabled = true },
	indent = { enabled = true, animate = { enabled = false } },
	notifier = { enabled = true, timeout = 3000 },
	scroll = { enabled = false },
	image = { enabled = true },
	dashboard = {
		enabled = true,
		preset = {
			keys = {
				{ icon = " ", key = "f", desc = "Find File", action = ":lua Snacks.dashboard.pick('files')" },
				{ icon = " ", key = "n", desc = "New File", action = ":ene | startinsert" },
				{ icon = " ", key = "g", desc = "Find Text", action = ":lua Snacks.dashboard.pick('live_grep')" },
				{ icon = " ", key = "r", desc = "Recent Files", action = ":lua Snacks.dashboard.pick('oldfiles')" },
				{ icon = " ", key = "s", desc = "Restore Session", section = "session" },
				{ icon = "󰒲 ", key = "L", desc = "Lazy", action = ":Lazy", enabled = package.loaded.lazy ~= nil },
				{ icon = " ", key = "Q", desc = "Quit", action = ":qa" },
			},
		},
		sections = {
			{ section = "header" },
			{ icon = " ", title = "Recent Files", section = "recent_files", indent = 2, padding = 1 },
			{ icon = " ", title = "Projects", section = "projects", indent = 2, padding = 1 },
			{ section = "keys", gap = 1, padding = 1 },
		},
	},
})

local map = vim.keymap.set

-- picker
map("n", "<leader>f", function()
	Snacks.picker.smart()
end, { desc = "Smart find" })
map("n", "ff", function()
	Snacks.picker.files()
end, { desc = "Files" })
map("n", "fg", function()
	Snacks.picker.grep()
end, { desc = "Grep" })
map("n", "fb", function()
	Snacks.picker.buffers()
end, { desc = "Buffers" })
map("n", "fh", function()
	Snacks.picker.help()
end, { desc = "Help" })
map("n", "fr", function()
	Snacks.picker.resume()
end, { desc = "Resume" })
map("n", "<leader>e", function()
	Snacks.explorer()
end, { desc = "Explorer" })

-- lsp
map("n", "gd", function()
	Snacks.picker.lsp_definitions()
end, { desc = "Definitions" })
map("n", "gr", function()
	Snacks.picker.lsp_references()
end, { desc = "References" })
map("n", "<leader>ss", function()
	Snacks.picker.lsp_symbols()
end, { desc = "Symbols" })
map("n", "]]", function()
	Snacks.words.jump(1, true)
end, { desc = "Next ref" })
map("n", "[[", function()
	Snacks.words.jump(-1, true)
end, { desc = "Prev ref" })

-- misc
map("n", "<leader>gg", function()
	Snacks.lazygit()
end, { desc = "Lazygit" })
map("n", "<leader>gB", function()
	Snacks.gitbrowse()
end, { desc = "Git browse" })
map("n", "<leader>bd", function()
	Snacks.bufdelete()
end, { desc = "Delete buffer" })
map("n", "<leader>.", function()
	Snacks.scratch()
end, { desc = "Scratch" })
map("n", "<leader>un", function()
	Snacks.notifier.hide()
end, { desc = "Dismiss notifs" })
map("n", "<c-\\>", function()
	Snacks.terminal()
end, { desc = "Terminal" })

local function close(force)
	return function()
		if #vim.api.nvim_tabpage_list_wins(0) > 1 then
			vim.cmd(force and "close!" or "close")
		else
			Snacks.bufdelete({ force = force })
		end
	end
end

map("n", "<C-w>", close(false), { nowait = true })
map("n", "<C-q>", close(true))

-- Snacks.rename integration only if you have oil/neo-tree; skip otherwise
Snacks.toggle.diagnostics():map("<leader>ud")
Snacks.toggle.inlay_hints():map("<leader>uh")
Snacks.toggle.line_number():map("<leader>ul")
