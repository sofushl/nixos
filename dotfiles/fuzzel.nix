{ config, pkgs, ... }:

{
  environment.systemPackages = [ pkgs.fuzzel ];
  environment.etc."xdg/fuzzel/fuzzel.ini" = {
    source = ./fuzzel.ini;
  };

}
