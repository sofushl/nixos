require("tmux").setup({
	copy_sync = { enable = false },
	navigation = { enable_navigation = true, cycle_navigation = true },
	resize = { enable_resize = true },
})

local map = vim.keymap.set
local tmux = require("tmux")

-- windows: C-hjkl in normal, visual, insert, terminal
for k, fn in pairs({ h = tmux.move_left, j = tmux.move_bottom, k = tmux.move_top, l = tmux.move_right }) do
	map({ "n", "x" }, "<C-" .. k .. ">", fn)
	map("i", "<C-" .. k .. ">", function()
		vim.cmd("stopinsert")
		fn()
	end)
	map("t", "<C-" .. k .. ">", function()
		vim.cmd("stopinsert")
		fn()
	end)
end
