{ config, pkgs, ... }:

{
  environment.systemPackages = [ pkgs.alacritty ];
  environment.etc = {
    "alacritty/alacritty.toml" = {
      source = ./alacritty.toml;
    };
  };
}
