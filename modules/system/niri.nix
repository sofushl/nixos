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

      xdg.icons.fallbackCursorThemes = [ "Bibata-Modern-Classic" ];
    };
}
