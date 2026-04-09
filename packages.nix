{ pkgs, config, ... }:

{
  # Package set
  environment.systemPackages = with pkgs; [

    # Applications
    libreoffice-fresh
    vesktop
    element-desktop
    spotify
    spicetify-cli
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

  imports = [
    ./vscodium/vscodium.nix
    ./dotfiles/librewolf/librewolf.nix
  ];
}
