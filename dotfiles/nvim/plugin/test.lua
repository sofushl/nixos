vim.g["test#strategy"] = "neovim"
vim.g["test#neovim#term_position"] = "vert botright 60"
vim.g["test#echo_command"] = 0

vim.keymap.set("n", "<leader>tt", "<cmd>TestNearest<cr>", { desc = "Test nearest" })
vim.keymap.set("n", "<leader>tf", "<cmd>TestFile<cr>", { desc = "Test file" })
vim.keymap.set("n", "<leader>ts", "<cmd>TestSuite<cr>", { desc = "Test suite" })
vim.keymap.set("n", "<leader>tl", "<cmd>TestLast<cr>", { desc = "Test last" })
