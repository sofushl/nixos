return {
    cmd = { "gopls" },
    filetypes = { "go", "gomod", "gowork", "gotmpl" },
    root_markers = { "go.work", "go.mod", ".git" },
    settings = {
        gopls = {
            gofumpt = true,
            staticcheck = true,
            analyses = { unusedparams = true, shadow = true },
            hints = { parameterNames = true, assignVariableTypes = true },
        },
    },
    on_attach = function(client, bufnr)
        local group = vim.api.nvim_create_augroup("GoplsFormat" .. bufnr, { clear = true })
        vim.api.nvim_create_autocmd("BufWritePre", {
            group = group,
            buffer = bufnr,
            callback = function()
                local params = vim.lsp.util.make_range_params(0, client.offset_encoding)
                params.context = { only = { "source.organizeImports" } }
                local result = vim.lsp.buf_request_sync(bufnr, "textDocument/codeAction", params, 3000)
                for client_id, res in pairs(result or {}) do
                    local c = vim.lsp.get_client_by_id(client_id)
                    for _, action in pairs(res.result or {}) do
                        if action.edit then
                            vim.lsp.util.apply_workspace_edit(action.edit, c and c.offset_encoding or "utf-16")
                        end
                    end
                end
                -- Then format
                vim.lsp.buf.format({ bufnr = bufnr, async = false })
            end,
        })
    end,
}
