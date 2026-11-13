require("conform").setup({
    formatters = {
        topcoat = {
            command = "topcoat",
            args = { "fmt", "--stdin" },
        },
    },
    formatters_by_ft = {
        lua = { "stylua" },
        python = { "black", "isort" },
        rust = { "rustfmt", "topcoat" },
        javascript = { "oxfmt" },
        typescript = { "oxfmt" },
        nix = { "nixfmt" },
        kdl = { "kdlfmt" },
        yaml = { "yamlfmt" },
        typst = { "typstyle" },
        go = { "gofmt" },
    },
    format_on_save = {
        timeout_ms = 5000,
        lsp_format = "fallback",
    },
})
