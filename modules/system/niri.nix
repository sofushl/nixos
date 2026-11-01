# REQUIRES HOME AND NIXOS IMPORT "niri"

{
  flake.nixosModules.niri =
    {
      pkgs,
      userconf,
      lib,
      ...
    }:
    {
      services.greetd = {
        enable = true;
        settings.default_session = {
          command = "${pkgs.niri}/bin/niri-session";
          user = userconf.username;
        };
      };

      programs.niri.enable = true;
      xdg.icons.fallbackCursorThemes = [ "Bibata-Modern-Classic" ];
    };
}
