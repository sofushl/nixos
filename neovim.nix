{
  config,
  pkgs,
  home-manager,
  ...
}:

{
  programs.neovim = {
    enable = true;
    defaultEditor = true;
    viAlias = true;
    vimAlias = true;
    vimdiffAlias = true;
    waylandSupport = true;

    plugins = with pkgs.vimPlugins; [
      neo-tree-nvim
      telescope-nvim
      vim-plug
      vim-nix
      vim-startify
      vscode-nvim
      nvim-lspconfig
      nvim-cmp
      cmp-nvim-lsp
      cmp-nvim-lsp-signature-help
      cmp-buffer
      cmp-path
      cmp-nvim-lsp-document-symbol
      cmp-nvim-lua
      cmp-nvim-tags
      cmp-nvim-ultisnips
      coc-prettier
      vim-prettier
      vim-javascript
      vim-javascript-syntax
    ];

    extraConfig = "colorscheme vscode";

    coc = {
      enable = true;
    };

    initLua = ''
      -- Helper for common on_attach behavior
      local on_attach = function(_, bufnr)
        local map = function(mode, lhs, rhs)
          vim.keymap.set(mode, lhs, rhs, { buffer = bufnr })
        end

        map("n", "gd", vim.lsp.buf.definition)
        map("n", "gr", vim.lsp.buf.references)
        map("n", "K", vim.lsp.buf.hover)
        map("n", "<leader>rn", vim.lsp.buf.rename)
        map("n", "<leader>ca", vim.lsp.buf.code_action)
      end

      -- Python (pyright)
      vim.lsp.config['pyright'] = {
        cmd = { "pyright-langserver", "--stdio" },
        filetypes = { "python" },
        root_markers = { ".git", "pyproject.toml", "requirements.txt" },
        on_attach = on_attach,
      }

      -- Lua
      vim.lsp.config['lua_ls'] = {
        cmd = { "lua-language-server" },
        filetypes = { "lua" },
        root_markers = { ".git", ".luarc.json", ".luarc.jsonc" },
        settings = {
          Lua = {
            runtime = { version = "LuaJIT" },
            diagnostics = { globals = { "vim" } },
          }
        },
        on_attach = on_attach,
      }

      -- Nix
      vim.lsp.config['nil_ls'] = {
        cmd = { "nil" },
        filetypes = { "nix" },
        root_markers = { "flake.nix", ".git" },
        on_attach = on_attach,
      }

      -- Rust
      vim.lsp.config['rust_analyzer'] = {
        cmd = { "rust-analyzer" },
        filetypes = { "rust" },
        root_markers = { "Cargo.toml", ".git" },
        on_attach = on_attach,
      }


      -- Enable all
      vim.lsp.enable('pyright')
      vim.lsp.enable('lua_ls')
      vim.lsp.enable('nil_ls')
      vim.lsp.enable('rust_analyzer')

    '';

  };
}
