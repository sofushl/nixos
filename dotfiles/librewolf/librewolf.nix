{
  config,
  pkgs,
  lib,
  ...
}:

let
  policies = {
    ExtensionSettings = {
      "minimal-dark-red@theme" = {
        installation_mode = "force_installed";
        install_url = "file://${myTheme}/theme.xpi";
      };
    };
  };

  policiesFile = pkgs.writeText "policies.json" (builtins.toJSON policies);

  myTheme = pkgs.stdenv.mkDerivation {
    name = "minimal-dark-red-theme";
    src = ./firefox-theme;

    nativeBuildInputs = [ pkgs.zip ];

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

    policies = policies;

    preferences = {
      "extensions.activeThemeID" = "minimal-dark-red@theme";
      "xpinstall.signatures.required" = false;
    };
  };

  environment.etc."librewolf/policies/policies.json".source = policiesFile;
}
