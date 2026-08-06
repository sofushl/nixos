return {
	cmd = { "typescript-language-server", "--stdio" },
	filetypes = { "javascript", "javascriptreact", "typescript", "typescriptreact" },
	root_markers = { { "tsconfig.json", "jsconfig.json" }, "package.json" },
	init_options = {
		hostInfo = "neovim",
		maxTsServerMemory = 4096,
	},
	settings = {
		completions = { completeFunctionCalls = false },
		typescript = {
			tsserver = { useSyntaxServer = "auto" },
			preferences = { includePackageJsonAutoImports = "off" },
			updateImportsOnFileMove = { enabled = "never" },
			inlayHints = {
				parameterNames = { enabled = "none" },
				variableTypes = { enabled = false },
				propertyDeclarationTypes = { enabled = false },
			},
		},
		javascript = {
			preferences = { includePackageJsonAutoImports = "off" },
		},
		files = {
			exclude = {
				"**/.git/**",
				"**/node_modules/**",
				"**/.hg/**",
				"**/.svn/**",
				"**/target/**",
				"**/.direnv/**",
				"**/result",
				"**/result-*",
				"**/dist/**",
				"**/build/**",
			},
		},
	},
	on_attach = function(client)
		vim.api.nvim_buf_create_user_command(0, "LspTypescriptSourceAction", function()
			local source_actions = vim.tbl_filter(function(action)
				return vim.startswith(action, "source.")
			end, client.server_capabilities.codeActionProvider.codeActionKinds)

			vim.lsp.buf.code_action({
				context = {
					only = source_actions,
					diagnostics = {},
				},
			})
		end, {})
	end,
}
