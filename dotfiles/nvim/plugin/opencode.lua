local oc_cmd = "opencode --port"
local oc_win = { win = { position = "right", enter = false } }

vim.g.opencode_opts = {
	server = {
		start = function()
			require("snacks.terminal").open(oc_cmd, oc_win)
		end,
	},
}

vim.keymap.set({ "n", "t" }, "<leader>o.", function()
	require("snacks.terminal").toggle(oc_cmd, oc_win)
end, { desc = "Toggle opencode" })

vim.keymap.set({ "n", "x" }, "<leader>oa", function()
	require("opencode").ask("@this: ")
end, { desc = "Ask opencode" })

vim.keymap.set({ "n", "x" }, "<leader>ox", function()
	require("opencode").select()
end, { desc = "Select opencode" })

vim.keymap.set({ "n", "x" }, "<leader>og", function()
	return require("opencode").operator("@this ")
end, { expr = true })

vim.keymap.set("n", "<leader>ou", function()
	require("opencode").command("session.half.page.up")
end)

vim.keymap.set("n", "<leader>os", function()
	require("opencode").command("session.half.page.down")
end)

vim.api.nvim_create_autocmd("User", {
	pattern = "OpencodeEvent:*", -- Optionally filter event types
	callback = function(args)
		---@type opencode.server.Event
		local event = args.data.event
		---@type string
		local url = args.data.url

		-- See the available event types and their properties
		vim.notify(vim.inspect(event))
		-- Do something useful
		if event.type == "session.status" then
			vim.notify("OpenCode status updated: " .. event.properties.status.type)
		end
	end,
})
