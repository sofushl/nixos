{ pkgs, ... }:

{
  # Package set
  environment.systemPackages = with pkgs; [

    # Applications
    librewolf
    vscodium
    libreoffice-fresh
    vesktop
    element-desktop
    spotify
    geteduroam
    scenebuilder
    fastfetch

    # Dev tools
    git
    openssh
    nixfmt
    tinymist
    kdlfmt
    graphviz
    uv
  ];
}
