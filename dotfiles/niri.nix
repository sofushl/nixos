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

  # Required tools
  environment.systemPackages = with pkgs; [
    pavucontrol
    playerctl
    brightnessctl
    cosmic-files
    bibata-cursors
    xwayland-satellite
  ];

}
