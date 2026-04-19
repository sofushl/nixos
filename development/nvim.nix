{
  pkgs,
  lib,
  config,
  ...
}:
{

  environment.shellAliases = {
    nvim-clean = "
      rm -rf ~/.config/nvim && \
      rm -rf ~/.cache/nvim && \
      rm -rf ~/.local/share/nvim
    ";
    nvim-cache = "
      rm -rf ~/.cache/nvim && \
      rm -rf ~/.local/share/nvim
    ";
  };

  programs.neovim = {
    enable = true;
    defaultEditor = true;
    viAlias = true;
    vimAlias = true;

    configure = {
      packages.myPlugins = {
        start = with pkgs.vimPlugins; [
          nvim-lspconfig
          nvim-treesitter
        ];
      };
    };

    runtime = {
      basicConfig = {
        enable = true;
        target = "lua/basic.lua";
        text = ''
          -- Enable syntax highlighting (fallback)
          vim.cmd("syntax on")

          -- Enable true color (important for highlighting)
          vim.opt.termguicolors = true

          -- Treesitter setup (better syntax highlighting)
          require'nvim-treesitter.configs'.setup {
            highlight = {
              enable = true,
            },
          }

          -- LSP setup (error highlighting)
          local lspconfig = require('lspconfig')

          -- Example: enable for common languages
          lspconfig.pyright.setup {}
          lspconfig.tsserver.setup {}
          lspconfig.rust_analyzer.setup {}

          -- Diagnostics appearance
          vim.diagnostic.config({
            virtual_text = true,
            signs = true,
            underline = true,
            update_in_insert = false,
          })
        '';
      };
    };

    withNodeJs = true;
    withPython3 = true;

  };

  environment.systemPackages = with pkgs; [

    # Dependencies
    git
    lazygit
    nerd-fonts.noto
    fd
    ripgrep
    fzf
    unzip
    wget
    gcc
    tree-sitter
    curl
    ast-grep
    imagemagick
    nodejs_24
    telescope
    stylua
    gzip
    gnutar

    # LSP
    pyright
    lua-language-server
    nil
    jdt-language-server
    rust-analyzer
    java-language-server
    javascript-typescript-langserver
  ];
}
