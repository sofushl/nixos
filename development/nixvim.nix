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

    globals.mapleader = " ";

    options = {
      relativenumber = true;
      incsearch = true;
    };

    colorschemes.onedark.enable = true;
    plugins.lualine.enable = true;
    plugins.nix.enable = true;

    plugins.treesitter.enable = true;

    plugins.telescope.enable = true;

    plugins.harpoon = {
      enable = true;
      keymaps.addFile = "<leader>a";
    };

    plugins.lsp = {
      keymaps = {
        silent = true;
        diagnostic = {
          "<leader>k" = "goto_prev";
          "<leader>j" = "goto_next";
        };

        lspBuf = {
          gd = "definition";
          K = "hover";
        };
      };
    };
  };
}
