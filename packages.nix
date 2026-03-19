{ pkgs, ... }:

{
  # Package set
  environment.systemPackages = with pkgs; [
    librewolf
    vscodium
    element-desktop
    openssh
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
    javaPackages.compiler.openjdk25
    javaPackages.openjfx25
    maven
  ];
}
