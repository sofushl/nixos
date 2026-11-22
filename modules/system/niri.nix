# Copyright (C) 2026 Sofus Højberg Lind
# SPDX-License-Identifier: AGPL-3.0-or-later

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
          command = "${pkgs.niri}/bin/niri-session";
          user = userconf.username;
        };
      };

      xdg.icons.fallbackCursorThemes = [ "Bibata-Modern-Classic" ];

      preservation.preserveAt."/persistent" = {
        users.${userconf.username} = {
          directories = [
            ".local/share/keyrings"
            ".local/state/wireplumber"

            ".librewolf"
            ".config/vesktop/sessionData/"
            ".config/Element"
            ".config/spotify"
            ".cache/spotify"
          ];
        };
      };
    };
}
