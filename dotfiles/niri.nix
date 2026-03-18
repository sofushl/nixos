{ config, pkgs, ... }:

{
  programs.niri.enable = true;

  services.xserver.enable = true;
  programs.xwayland.enable = true;

  environment.etc."niri/config.kdl" = {
    source = ./niri.kdl;
  };

  environment.systemPackages = with pkgs; [
    cosmic-files
    bibata-cursors
  ];

  environment.variables = {
    XCURSOR_THEME = "Bibata-Modern-Classic";
    XCURSOR_SIZE = "20";
  };

  imports = [
    ./fuzzel.nix
    ./alacritty.nix
  ];

}
