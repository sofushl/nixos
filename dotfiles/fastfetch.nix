{ config, pkgs, ... }:

{
  environment.systemPackages = [ pkgs.fastfetch ];

  environment.etc."fastfetch/config.jsonc".source = ./fastfetch.jsonc;

  environment.etc."fastfetch/logo.txt".source = ./abacordascii.txt;
}
