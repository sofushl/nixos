{config, pkgs, ...}:

{
  wsl.enable = true;
  wsl.startMenuLaunchers = true;

  imports = [
     <nixos-wsl/modules>
    ./dotfiles/niri.nix
    ./main.nix
    ./dotfiles/librewolf/librewolf.nix
  ];

  # Package set
  environment.systemPackages = with pkgs; [

    # Applications
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