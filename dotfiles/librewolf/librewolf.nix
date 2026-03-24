{ config, pkgs, ... }:

let
  myTheme = pkgs.stdenv.mkDerivation {
    name = "minimal-dark-red-theme";
    src = ./firefox-theme;

    nativeBuildInputs = [ pkgs.zip ]; # <- required

    installPhase = ''
      mkdir -p $out
      cd $src
      zip -r $out/theme.xpi .
    '';
  };
in

{
  programs.firefox = {
    enable = true;
    package = pkgs.librewolf;
  }
  environment.etc."librewolf/policies/policies.json".source = ./policies.json;
}
