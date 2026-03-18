{ config, ... }:

{
  # User account
  users.users.USERNAME = {
    isNormalUser = true;
    description = "NAME";
    extraGroups = [
      "networkmanager"
      "wheel"
    ];
  };

  networking.hostName = "Nixos";

  imports = [
    ./cosmic.nix
    ./main.nix
    ./packages.nix
    ./dotfiles/alacritty.nix
    ./dotfiles/niri.nix
  ];
}
