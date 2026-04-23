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
    vscodium

    # Dev tools
    git
    gitui
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
    gzip
    gnutar
    nodejs_25
    librewolf
  ];
}
