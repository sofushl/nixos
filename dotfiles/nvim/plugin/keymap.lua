local map = vim.keymap.set

map({ "n", "v" }, "q", "<cmd>Yazi<CR>")

map({ "n", "v" }, "<C-S-Q>", "<cmd>qa<CR>")

-- Norwegian keymap remap
map({ "n", "v", "x" }, "å", "{")
map({ "n", "v", "x" }, "¨", "}")
map({ "n", "v", "x" }, "ø", ":")
map({ "n", "v", "x" }, "æ", '"')

map("n", "gh", vim.diagnostic.open_float)
map("n", "gs", vim.lsp.buf.hover)
map("n", "gd", vim.lsp.buf.definition)

map({ "n", "v", "x" }, "<leader>k", "<cmd>vsplit<CR>")
map({ "n", "v", "x" }, "<leader>j", "<cmd>split<CR>")

-- buffers
map("n", "<leader>h", "<Cmd>BufferLineCyclePrev<CR>")
map("n", "<leader>l", "<Cmd>BufferLineCycleNext<CR>")

-- claude
map({ "n", "x" }, "<C-,>", "<cmd>ClaudeCodeFocus<cr>", { desc = "Claude" })
map({ "n", "x" }, "<leader>,", "<cmd>ClaudeCodeFocus<cr>", { desc = "Claude" })
map("n", "<leader>ar", "<cmd>ClaudeCode --resume<cr>", { desc = "Resume" })
map("n", "<leader>am", "<cmd>ClaudeCodeSelectModel<cr>", { desc = "Model" })
map("n", "<leader>ab", "<cmd>ClaudeCodeAdd %<cr>", { desc = "Add buffer" })
map("x", "<leader>as", "<cmd>ClaudeCodeSend<cr>", { desc = "Send selection" })
map("n", "<leader>aa", "<cmd>ClaudeCodeDiffAccept<cr>", { desc = "Accept diff" })
map("n", "<leader>ax", "<cmd>ClaudeCodeDiffDeny<cr>", { desc = "Deny diff" })

--tmux
local tmux = require("tmux")

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

--vimtest
map("n", "<leader>tt", "<cmd>TestNearest<cr>", { desc = "Test nearest" })
map("n", "<leader>tf", "<cmd>TestFile<cr>", { desc = "Test file" })
map("n", "<leader>ts", "<cmd>TestSuite<cr>", { desc = "Test suite" })
map("n", "<leader>tl", "<cmd>TestLast<cr>", { desc = "Test last" })

-- snacks
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

map("n", "[[", function()
	Snacks.words.jump(1, true)
end, { desc = "Next ref" })

map("n", "]]", function()
	Snacks.words.jump(-1, true)
end, { desc = "Prev ref" })

-- misc
map("n", "<leader>gg", function()
	Snacks.lazygit()
end, { desc = "Lazygit" })

map("n", "<leader>gb", function()
	Snacks.gitbrowse()
end, { desc = "Git browse" })

local function close(force)
	return function()
		if #vim.api.nvim_tabpage_list_wins(0) > 1 then
			vim.cmd(force and "close!" or "close")
		else
			Snacks.bufdelete({ force = force })
		end
	end
end

map({ "n", "v", "x" }, "<C-q>", close(false), { desc = "Delete buffer" })

map({ "n", "v", "x" }, "Q", close(true), { desc = "Delete buffer" })

map("n", "<leader>un", function()
	Snacks.notifier.hide()
end, { desc = "Dismiss notifs" })

map("n", "<C-.>", function()
	Snacks.terminal()
end, { desc = "Terminal" })

map("n", "<leader>.", function()
	Snacks.terminal()
end, { desc = "Scratch" })

-- Snacks.rename integration only if you have oil/neo-tree; skip otherwise
Snacks.toggle.diagnostics():map("<leader>ud")
Snacks.toggle.inlay_hints():map("<leader>uh")
Snacks.toggle.line_number():map("<leader>ul")
