# REQUIRES HOME AND NIXOS IMPORT "niri"

{
  flake.nixosModules.niri =
    {
      pkgs,
      inputs,
      userconf,
      lib,
      ...
    }:
    {
      services.greetd = {
        enable = true;
        settings.default_session = {
          command = "${
            inputs.niri.packages.${pkgs.stdenv.hostPlatform.system}.niri-unstable
          }/bin/niri-session";
          user = userconf.username;
        };
      };

      programs.niri = {
        enable = true;
        package = inputs.niri.packages.${pkgs.stdenv.hostPlatform.system}.niri-unstable;
        useNautilus = true;
      };

      xdg.portal = {
        enable = true;
        extraPortals = [
          pkgs.xdg-desktop-portal-gtk
          pkgs.xdg-desktop-portal-wlr
          pkgs.xdg-desktop-portal-gnome
        ];
        config.common.default = [ "gtk" ];
      };

      xdg.icons.fallbackCursorThemes = [ "Bibata-Modern-Classic" ];
    };
}
