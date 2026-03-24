{config, pkgs, ...}:

{
  wsl.enable = true;
  wsl.startMenuLaunchers = true;

  imports = [
     <nixos-wsl/modules>
    ./dotfiles/niri.nix
    ./main.nix
    ./vscodium/vscodium.nix
    ./dotfiles/librewolf/librewolf.nix
  ];

  # Package set
  environment.systemPackages = with pkgs; [

    # Applications
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