{ pkgs, config, ... }:

{

  # Package set
  environment.systemPackages = with pkgs; [

    # Applications
    libreoffice-fresh
    vesktop
    discordo
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
    ./nvim/nvim.nix
    ./niri/librewolf.nix
  ];
}
