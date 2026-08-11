require("claudecode").setup({
	terminal_cmd = vim.g.claudecode_cmd,
	auto_start = true,
	log_level = "warn",
	focus_after_send = true,
	git_repo_cwd = true,

	terminal = {
		provider = "snacks",
		snacks_win_opts = {
			position = "right",
			width = 0.35,
			keys = {
				claude_hide = {
					"<C-,>",
					function(self)
						self:hide()
					end,
					mode = "t",
					desc = "Hide",
				},
			},
		},
	},

	diff_opts = {
		layout = "vertical",
		keep_terminal_focus = false,
		on_new_file_reject = "close_window",
	},
})

local map = vim.keymap.set
map({ "n", "x" }, "<C-,>", "<cmd>ClaudeCodeFocus<cr>", { desc = "Claude" })
map("n", "<leader>ar", "<cmd>ClaudeCode --resume<cr>", { desc = "Resume" })
map("n", "<leader>am", "<cmd>ClaudeCodeSelectModel<cr>", { desc = "Model" })
map("n", "<leader>ab", "<cmd>ClaudeCodeAdd %<cr>", { desc = "Add buffer" })
map("x", "<leader>as", "<cmd>ClaudeCodeSend<cr>", { desc = "Send selection" })
map("n", "<leader>aa", "<cmd>ClaudeCodeDiffAccept<cr>", { desc = "Accept diff" })
map("n", "<leader>ax", "<cmd>ClaudeCodeDiffDeny<cr>", { desc = "Deny diff" })
