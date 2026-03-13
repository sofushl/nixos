{ pkgs, ... }:

{
  # Package set
  environment.systemPackages = with pkgs; [
    librewolf
    vscodium
    element-desktop
    openssh
    javaPackages.compiler.openjdk25
    geteduroam
    discord
    git
    libreoffice-fresh
    fastfetch
    nixfmt
    tinymist
    scenebuilder
    graphviz
    spotify
    alacritty
    uv
  ];
}
