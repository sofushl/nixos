local opencode_cmd = "opencode"

---@type snacks.terminal.Opts
local snacks_terminal_opts = {
    win = {
        position = "right",
        enter = false,
    },
}

---@type opencode.Opts
vim.g.opencode_opts = {
    server = {
        start = function()
            require("snacks.terminal").open(opencode_cmd, snacks_terminal_opts)
        end,
    },
}

-- No <leader> here: 't' mode would add input delay to <leader> when typing in the terminal
vim.keymap.set({ "n", "t" }, "<C-.>", function()
    require("snacks.terminal").toggle(opencode_cmd, snacks_terminal_opts)
end, { desc = "Toggle OpenCode" })

vim.keymap.set({ "n", "x" }, "<C-a>", function()
    require("opencode").ask("@this: ")
end, { desc = "Ask OpenCode…" })

vim.keymap.set({ "n", "x" }, "<C-x>", function()
    require("opencode").select()
end, { desc = "Select OpenCode…" })

vim.keymap.set({ "n", "x" }, "go", function()
    return require("opencode").operator("@this")
end, { desc = "Send range to OpenCode", expr = true })

vim.keymap.set("n", "goo", function()
    return require("opencode").operator("@this") .. "_"
end, { desc = "Send line to OpenCode", expr = true })

-- Show the terminal when OpenCode starts executing
vim.api.nvim_create_autocmd("User", {
    pattern = { "OpencodeEvent:session.execution.started" },
    callback = function()
        local win = require("snacks.terminal").get(opencode_cmd, { create = false })
        if win then
            win:show()
        end
    end,
})
