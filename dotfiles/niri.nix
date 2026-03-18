{ config, pkgs, ... }:

{
  programs.niri.enable = true;
  environment.etc."niri/config.kdl" = {
    source = ./niri.kdl;
  };
}
