{ pkgs, lib, ... }:
{
  programs.neovim = {
    enable = true;
    defaultEditor = true;
    viAlias = true;
    vimAlias = true;
    vimdiffAlias = true;
    waylandSupport = true;

    plugins = with pkgs.vimPlugins; [
      nvim-tree-lua
      neo-tree-nvim
      telescope-nvim
      project-nvim
      persistence-nvim
      lazygit-nvim
      vim-plug
      vim-nix
      vim-startify
      conform-nvim
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
      vim-prettier
      vim-javascript
      vim-javascript-syntax
      toggleterm-nvim
      python-mode
      vim-wayland-clipboard
    ];

    extraConfig = "colorscheme vscode";

    coc.enable = false;

    initLua = builtins.readFile ../../dotfiles/neovim.lua;
  };

  programs.helix = {
    enable = true;
    settings = {
      theme = "gruvbox-material";
    };
  };
}
