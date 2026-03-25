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
    # Activate the theme by default
    preferences = {
      "extensions.activeThemeID" = "minimal-dark-red@theme";
      "xpinstall.signatures.required" = false;
    };
  };

  environment.etc."librewolf/policies/policies.json".text = builtins.toJSON {
    policies = {
      ExtensionSettings = {
        "minimal-dark-red@theme" = {
          install_url = "file://${myTheme}/theme.xpi";
          installation_mode = "force_installed";
        };
      };
    };

  };
}
