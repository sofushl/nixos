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

    # Dev tools
    git
    openssh
    nixfmt
    tinymist
    kdlfmt
    graphviz
    uv
    btop
    nodejs_24
  ];

  imports = [
    ./development/vscodium/vscodium.nix
    ./development/nvim.nix

    ./niri/librewolf.nix
  ];
}
