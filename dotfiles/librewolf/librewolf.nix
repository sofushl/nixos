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

    # Force install the theme via enterprise policy
    policies = {
      ExtensionSettings = {
        "minimal-dark-red@theme" = {
          installation_mode = "force_installed";
          install_url = "file://${myTheme}/theme.xpi";
        };
      };
    };

    # Activate the theme by default
    preferences = {
      "extensions.activeThemeID" = "minimal-dark-red@theme";
      "xpinstall.signatures.required" = false;
    };
  };

  environment.etc."librewolf/policies/policies.json".source = /etc/firefox/policies/policies.json;
}
