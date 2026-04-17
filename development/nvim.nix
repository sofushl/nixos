{ pkgs, config, ... }:

{
  programs.neovim = {
    enable = true;
    defaultEditor = true;
    viAlias = true;
    vimAlias = true;
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
    nvim-lspconfig
    nodejs_24
    telescope-nvim
    nvim-tree-lua
    plenary-nvim
    stylua

    # LSP
    nvim-lspconfig
    pyright
    lua-language-server
    nil
    jdt-language-server
    rust-analyzer
    java-language-server
    javascript-typescript-langserver
  ];
}
