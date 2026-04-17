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
