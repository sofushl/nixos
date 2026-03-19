{ config, pkgs, ... }:

{
  programs.niri.enable = true;

  environment.etc."niri/config.kdl" = {
    source = ./niri.kdl;
  };

  environment.systemPackages = with pkgs; [
    cosmic-files
    bibata-cursors
    xwayland-satellite
  ];

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
  ];

  programs.waybar.enable = true;

  environment.etc."xdg/waybar" = {
    source = ./waybar;
  };

}
