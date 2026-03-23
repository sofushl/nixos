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
    ./main.nix
    ./packages.nix
    ./dotfiles/niri.nix
  ];
}
