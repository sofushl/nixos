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
    git
    libreoffice-fresh
    fastfetch
    nixfmt
    vesktop
    tinymist
    scenebuilder
    graphviz
    spotify
    uv
    kdlfmt
  ];
}
