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

  import = [
    ./nixvim.nix
  ];

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
