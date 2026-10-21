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
