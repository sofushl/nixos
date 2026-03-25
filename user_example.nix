{ config, pkgs, ... }:

{
  # Bootloader
  boot.loader.systemd-boot.enable = true; # false on WSL
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
    # <nixos-wsl/modules>
    ./main.nix
    ./packages.nix
    ./dotfiles/niri.nix
  ];

  # For wsl
  #wsl.enable = true;
  #wsl.startMenuLaunchers = true;
  #wsl.defaultUser = "USERNAME";
}
