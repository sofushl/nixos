local map = vim.keymap.set

-- plugin/ is sourced alphabetically, so snacks.lua runs *after* this file.
-- Require it here so the `Snacks` global exists for the toggles at the bottom.
local Snacks = require("snacks")

map({ "n", "v" }, "q", "<cmd>Yazi<CR>")

map({ "n", "v" }, "<C-S-Q>", "<cmd>qa<CR>")

-- Norwegian keymap remap
map({ "n", "v", "x" }, "å", "{")
map({ "n", "v", "x" }, "¨", "}")
map({ "n", "v", "x" }, "ø", ":")
map({ "n", "v", "x" }, "æ", '"')

map({ "n", "v", "x" }, "<leader>k", "<cmd>vsplit<CR>")
map({ "n", "v", "x" }, "<leader>j", "<cmd>split<CR>")

-- buffers
map("n", "<leader>h", "<Cmd>BufferLineCyclePrev<CR>")
map("n", "<leader>l", "<Cmd>BufferLineCycleNext<CR>")

map("n", "gs", vim.lsp.buf.hover)
map("n", "gd", vim.lsp.buf.definition)

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

-- snacks: files (`f` prefix)
map("n", "<leader>f", function()
	Snacks.picker.smart()
end, { desc = "Smart find" })

map("n", "ff", function()
	Snacks.picker.files()
end, { desc = "Files" })

map("n", "fg", function()
	Snacks.picker.grep()
end, { desc = "Grep" })

map("n", "fn", function()
	Snacks.picker.grep_buffers()
end, { desc = "Grep open buffers" })

map("n", "fl", function()
	Snacks.picker.lines()
end, { desc = "Lines" })

map("n", "fb", function()
	Snacks.picker.buffers()
end, { desc = "Buffers" })

map("n", "fh", function()
	Snacks.picker.help()
end, { desc = "Help" })

map("n", "fr", function()
	Snacks.picker.resume()
end, { desc = "Resume" })

map("n", "fc", function()
	Snacks.picker.files({ cwd = vim.fn.stdpath("config") })
end, { desc = "Config files" })

map("n", "fG", function()
	Snacks.picker.git_files()
end, { desc = "Git files" })

map("n", "fp", function()
	Snacks.picker.projects()
end, { desc = "Projects" })

map("n", "fo", function()
	Snacks.picker.recent()
end, { desc = "Recent" })

map("n", "<leader>e", function()
	Snacks.explorer()
end, { desc = "Explorer" })

-- snacks: search (`<leader>s` prefix)
map("n", "<leader>:", function()
	Snacks.picker.command_history()
end, { desc = "Command history" })

map("n", '<leader>s"', function()
	Snacks.picker.registers()
end, { desc = "Registers" })

map("n", "<leader>s/", function()
	Snacks.picker.search_history()
end, { desc = "Search history" })

map("n", "<leader>sa", function()
	Snacks.picker.autocmds()
end, { desc = "Autocmds" })

map("n", "<leader>sb", function()
	Snacks.picker.lines()
end, { desc = "Buffer lines" })

map("n", "<leader>sB", function()
	Snacks.picker.grep_buffers()
end, { desc = "Grep open buffers" })

map("n", "<leader>sc", function()
	Snacks.picker.command_history()
end, { desc = "Command history" })

map("n", "<leader>sC", function()
	Snacks.picker.commands()
end, { desc = "Commands" })

map("n", "<leader>sd", function()
	Snacks.picker.diagnostics()
end, { desc = "Diagnostics" })

map("n", "<leader>sD", function()
	Snacks.picker.diagnostics_buffer()
end, { desc = "Buffer diagnostics" })

map("n", "<leader>sg", function()
	Snacks.picker.grep()
end, { desc = "Grep" })

map({ "n", "x" }, "<leader>sw", function()
	Snacks.picker.grep_word()
end, { desc = "Visual selection or word" })

map("n", "<leader>sh", function()
	Snacks.picker.help()
end, { desc = "Help pages" })

map("n", "<leader>sH", function()
	Snacks.picker.highlights()
end, { desc = "Highlights" })

map("n", "<leader>si", function()
	Snacks.picker.icons()
end, { desc = "Icons" })

map("n", "<leader>sj", function()
	Snacks.picker.jumps()
end, { desc = "Jumps" })

map("n", "<leader>sk", function()
	Snacks.picker.keymaps()
end, { desc = "Keymaps" })

map("n", "<leader>sl", function()
	Snacks.picker.loclist()
end, { desc = "Location list" })

map("n", "<leader>sm", function()
	Snacks.picker.marks()
end, { desc = "Marks" })

map("n", "<leader>sM", function()
	Snacks.picker.man()
end, { desc = "Man pages" })

map("n", "<leader>sq", function()
	Snacks.picker.qflist()
end, { desc = "Quickfix list" })

map("n", "<leader>sR", function()
	Snacks.picker.resume()
end, { desc = "Resume" })

map("n", "<leader>su", function()
	Snacks.picker.undo()
end, { desc = "Undo history" })

map("n", "<leader>n", function()
	Snacks.picker.notifications()
end, { desc = "Notification history" })

-- lsp
map("n", "gd", function()
	vim.lsp.buf.definition()
end, { desc = "Goto definition" })

map("n", "gD", function()
	Snacks.picker.lsp_declarations()
end, { desc = "Goto declaration" })

map("n", "gr", function()
	Snacks.picker.lsp_references()
end, { nowait = true, desc = "References" })

map("n", "gI", function()
	Snacks.picker.lsp_implementations()
end, { desc = "Goto implementation" })

map("n", "gy", function()
	Snacks.picker.lsp_type_definitions()
end, { desc = "Goto t[y]pe definition" })

map("n", "gai", function()
	Snacks.picker.lsp_incoming_calls()
end, { desc = "C[a]lls incoming" })

map("n", "gao", function()
	Snacks.picker.lsp_outgoing_calls()
end, { desc = "C[a]lls outgoing" })

map("n", "<leader>ss", function()
	Snacks.picker.lsp_symbols()
end, { desc = "LSP symbols" })

map("n", "<leader>sS", function()
	Snacks.picker.lsp_workspace_symbols()
end, { desc = "LSP workspace symbols" })

map({ "n", "t" }, "]]", function()
	Snacks.words.jump(vim.v.count1)
end, { desc = "Next reference" })

map({ "n", "t" }, "[[", function()
	Snacks.words.jump(-vim.v.count1)
end, { desc = "Prev reference" })

-- git
map("n", "<leader>gg", function()
	Snacks.lazygit()
end, { desc = "Lazygit" })

map({ "n", "v" }, "<leader>gb", function()
	Snacks.gitbrowse()
end, { desc = "Git browse" })

map("n", "<leader>gB", function()
	Snacks.picker.git_branches()
end, { desc = "Git branches" })

map("n", "<leader>gl", function()
	Snacks.picker.git_log()
end, { desc = "Git log" })

map("n", "<leader>gL", function()
	Snacks.picker.git_log_line()
end, { desc = "Git log line" })

map("n", "<leader>gf", function()
	Snacks.picker.git_log_file()
end, { desc = "Git log file" })

map("n", "<leader>gs", function()
	Snacks.picker.git_status()
end, { desc = "Git status" })

map("n", "<leader>gS", function()
	Snacks.picker.git_stash()
end, { desc = "Git stash" })

map("n", "<leader>gd", function()
	Snacks.picker.git_diff()
end, { desc = "Git diff (hunks)" })

-- gh
map("n", "<leader>gi", function()
	Snacks.picker.gh_issue()
end, { desc = "GitHub issues (open)" })

map("n", "<leader>gI", function()
	Snacks.picker.gh_issue({ state = "all" })
end, { desc = "GitHub issues (all)" })

map("n", "<leader>gp", function()
	Snacks.picker.gh_pr()
end, { desc = "GitHub PRs (open)" })

map("n", "<leader>gP", function()
	Snacks.picker.gh_pr({ state = "all" })
end, { desc = "GitHub PRs (all)" })

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

map({ "n", "v", "x" }, "Q", close(true), { desc = "Delete buffer!" })

map("n", "<leader>un", function()
	Snacks.notifier.hide()
end, { desc = "Dismiss notifs" })

map("n", "<C-.>", function()
	Snacks.terminal()
end, { desc = "Terminal" })

map("n", "<leader>.", function()
	Snacks.scratch()
end, { desc = "Scratch" })

map("n", "<leader>S", function()
	Snacks.scratch.select()
end, { desc = "Select scratch buffer" })

map("n", "<leader>z", function()
	Snacks.zen()
end, { desc = "Zen mode" })

map("n", "<leader>Z", function()
	Snacks.zen.zoom()
end, { desc = "Zoom" })

map("n", "<leader>cR", function()
	Snacks.rename.rename_file()
end, { desc = "Rename file" })

-- toggles
Snacks.toggle.diagnostics():map("<leader>ud")
Snacks.toggle.inlay_hints():map("<leader>uh")
Snacks.toggle.line_number():map("<leader>ul")

Snacks.toggle.zen():map("<leader>uz")
Snacks.toggle.indent():map("<leader>ug")
Snacks.toggle.dim():map("<leader>uD")

map("n", "<leader>uC", function()
	Snacks.picker.colorschemes()
end, { desc = "Colorschemes" })
