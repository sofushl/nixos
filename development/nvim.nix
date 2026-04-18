{
  pkgs,
  lib,
  config,
  ...
}:
let
  nixvim = import (
    builtins.fetchGit {
      url = "https://github.com/nix-community/nixvim";
      # If you are not running an unstable channel of nixpkgs, select the corresponding branch of Nixvim.
      # ref = "nixos-25.11";
    }
  );
in
{
  imports = [
    nixvim.nixosModules.nixvim
  ];

  programs.nixvim = {
    enable = true;
    defaultEditor = true;
    viAlias = true;
    vimAlias = true;

    # Basic editor settings
    opts = {
      number = true;
      relativenumber = true;
      shiftwidth = 2;
      tabstop = 2;
      expandtab = true;
    };

    # Leader key
    globals.mapleader = " ";

    plugins = {
      # File explorer
      nvim-tree.enable = true;

      # Statusline
      lualine.enable = true;

      # Telescope (fuzzy finder)
      telescope.enable = true;

      # Treesitter (syntax + parsing)
      treesitter = {
        enable = true;
        settings = {
          highlight.enable = true;
        };
      };

      # LSP
      lsp = {
        enable = true;

        servers = {
          nil_ls.enable = true; # nix
          tsserver.enable = true; # javascript/typescript
          pyright.enable = true; # python
          rust-analyzer.enable = true;
        };
      };

      # Autocomplete
      cmp = {
        enable = true;
        autoEnableSources = true;
      };

      # Git
      gitsigns.enable = true;
    };

    keymaps = [
      {
        mode = "n";
        key = "<leader>ff";
        action = "<cmd>Telescope find_files<CR>";
      }
      {
        mode = "n";
        key = "<leader>fg";
        action = "<cmd>Telescope live_grep<CR>";
      }
      {
        mode = "n";
        key = "<leader>e";
        action = "<cmd>NvimTreeToggle<CR>";
      }
    ];
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
