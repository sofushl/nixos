{ config, pkgs, ... }:

{

  # Bootloader
  boot.loader.systemd-boot.enable = true;
  boot.loader.efi.canTouchEfiVariables = true;

  # Kernel
  boot.kernelPackages = pkgs.linuxPackages_latest;
  
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
