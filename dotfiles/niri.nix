{ config, pkgs, ... }:

{
  programs.niri.enable = true;

  environment.etc."niri/config.kdl" = {
    source = ./niri.kdl;
  };

  environment.variables = {
    XCURSOR_THEME = "Bibata-Modern-Classic";
    XCURSOR_SIZE = "20";
  };

  environment.sessionVariables = {
    XCURSOR_THEME = "Bibata-Modern-Classic";
    XCURSOR_SIZE = "20";
  };

  imports = [
    ./fuzzel.nix
    ./alacritty.nix
    ./librewolf.nix
  ];

  # Waybar
  programs.waybar.enable = true;
  #https://man.archlinux.org/man/waybar.5

  environment.etc."xdg/waybar" = {
    source = ./waybar;
  };

  # Audio (PipeWire is standard on NixOS now)
  services.pipewire = {
    enable = true;
    pulse.enable = true;
    alsa.enable = true;
  };

  # Brightness control
  programs.light.enable = true;

  # Enable networking
  networking.networkmanager.enable = true;

  # USB management
  services.udisks2.enable = true;
  services.gvfs.enable = true;

  # Required tools
  environment.systemPackages = with pkgs; [

    # Environment applications
    cosmic-files

    # Environment controllers
    pavucontrol
    playerctl
    brightnessctl

    # Customization
    bibata-cursors

    # X11 support for niri
    xwayland-satellite

    #USB disk management
    usbutils
    udiskie
  ];

}
