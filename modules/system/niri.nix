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

      programs.niri = {
        enable = true;
        package = pkgs.niri;
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
