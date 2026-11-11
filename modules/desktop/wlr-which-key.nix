# Copyright (C) 2026 Sofus Højberg Lind
# SPDX-License-Identifier: AGPL-3.0-or-later

{
  flake.homeModules.wlrWhichKey =
    {
      pkgs,
      lib,
      userconf,
      ...
    }:
    let
      c = userconf.theme;

      menuStyle = {
        anchor = "center";
        background = c.bg.primary;
        color = c.text.primary;

        border = c.primary;
        border_width = 5;
        padding = 10;
      };
    in
    {

      programs.wlr-which-key = {
        enable = true;
        package = pkgs.wlr-which-key;

        extraMenus = {
          apps = menuStyle // {
            menu = [
              {
                key = "a";
                desc = "Element";
                cmd = lib.getExe pkgs.element-desktop;
              }
              {
                key = "s";
                desc = "Spotify";
                cmd = lib.getExe pkgs.spotify;
              }
              {
                key = "d";
                desc = "Vesktop";
                cmd = lib.getExe pkgs.vesktop;
              }
              {
                key = "f";
                desc = "VLC Media Player";
                cmd = lib.getExe pkgs.vlc;
              }
              {
                key = "g";
                desc = "Loupe";
                cmd = lib.getExe pkgs.loupe;
              }
            ];
          };

          system = menuStyle // {
            menu = [
              {
                key = "a";
                desc = "Waybar";
                cmd = "${pkgs.systemd}/bin/systemctl --user restart waybar";
              }
              {
                key = "s";
                desc = "Sunsetr";
                cmd = "${pkgs.systemd}/bin/systemctl --user restart sunsetr";
              }
              {
                key = "d";
                desc = "Dark";
                cmd = "${lib.getExe pkgs.sunsetr} preset dark";
              }
              {
                key = "f";
                desc = "Brigth";
                cmd = "${lib.getExe pkgs.sunsetr} preset bright";
              }
              {
                key = "g";
                desc = "Default";
                cmd = "${lib.getExe pkgs.sunsetr} preset default";
              }
            ];
          };
        };
      };
    };
}
