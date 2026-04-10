{ config, pkgs, ... }:

{
  # Bootloader defined in user.nix for wsl purposes, see user_example.nix

  # Set time zone.
  time.timeZone = "Europe/Oslo";

  # Select internationalisation properties.
  i18n.defaultLocale = "en_GB.UTF-8";

  i18n.extraLocaleSettings = {
    LC_ADDRESS = "nb_NO.UTF-8";
    LC_IDENTIFICATION = "nb_NO.UTF-8";
    LC_MEASUREMENT = "nb_NO.UTF-8";
    LC_MONETARY = "nb_NO.UTF-8";
    LC_NAME = "nb_NO.UTF-8";
    LC_NUMERIC = "nb_NO.UTF-8";
    LC_PAPER = "nb_NO.UTF-8";
    LC_TELEPHONE = "nb_NO.UTF-8";
    LC_TIME = "nb_NO.UTF-8";
  };

  # Keyboard config
  console.keyMap = "no";
  services.xserver.xkb = {
    layout = "no";
    variant = "winkeys";
  };

  # Enable networking
  networking.networkmanager.enable = true;

  networking.networkmanager.settings.connectivity = {
    enabled = true;
    uri = "http://connectivity-check.ubuntu.com/";
    response = "NetworkManager is online";
  };

  #programs.captive-browser.enable = true;

  # Enable bluetooth
  hardware.bluetooth.enable = true;

  # Enable sound with pipewire.
  services.pulseaudio.enable = false;
  security.rtkit.enable = true;
  services.pipewire = {
    enable = true;
    alsa.enable = true;
    alsa.support32Bit = true;
    pulse.enable = true;
    jack.enable = true;
  };

  # Allow unfree packages
  nixpkgs.config.allowUnfree = true;

  # Nix stuff?
  nix.settings = {
    experimental-features = [
      "nix-command"
      "flakes"
    ];
  };

  environment.shellAliases = {
    nixos-reset = "
      sudo nixos-rebuild switch && \
      sudo nix-collect-garbage -d && \
      sudo rm -rf ~/.cache/* && \
      sudo rm -rf /var/cache/* && \
      sudo find /tmp -mindepth 1 -delete && \
      sudo find /var/tmp -mindepth 1 -delete && \
      sudo nix-store --optimise 
    ";
  };

  # Enable CUPS to print documents.
  services.printing.enable = true;

  #SSH support
  services.openssh.enable = true;

  programs.nix-ld.enable = true;

  hardware.graphics.enable = true;

  # system version variable
  system.stateVersion = "25.11";
}
