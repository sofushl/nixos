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
    jetbrains.idea-oss
    btop
  ];

  imports = [
    ./applications/vscodium/vscodium.nix
    ./applications/nvim/nvim.nix
    ./niri/librewolf.nix
  ];
}
