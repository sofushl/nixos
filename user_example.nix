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
  programs.captive-browser.interface = "wlp0s20f3";

  imports = [
    # <nixos-wsl/modules>
    ./main.nix
    ./packages.nix
    ./niri/niri.nix
  ];

  swapDevices = [
    {
      device = "/swapfile";
      size = 8 * 1024; # size in MB (here:84 GB)
    }
  ];

  # For wsl
  #wsl.enable = true;
  #wsl.startMenuLaunchers = true;
  #wsl.defaultUser = "USERNAME";
}
