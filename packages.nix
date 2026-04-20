{ pkgs, config, ... }:

{

  # Package set
  environment.systemPackages = with pkgs; [

    # Applications
    onlyoffice-desktopeditors
    vesktop
    spotify
    spicetify-cli
    geteduroam
    scenebuilder
    fastfetch
    helix

    # Dev tools
    git
    openssh
    nixfmt
    tinymist
    kdlfmt
    graphviz
    uv
    btop
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
    gzip
    gnutar
  ];

  imports = [
    ./development/vscodium/vscodium.nix
    #./development/nvim.nix

    ./niri/librewolf.nix
  ];
}
