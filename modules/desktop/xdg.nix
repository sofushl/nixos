# Copyright (C) 2026 Sofus Højberg Lind
# SPDX-License-Identifier: AGPL-3.0-or-later

{
  flake.homeModules.xdg =
    {
      pkgs,
      config,
      userconf,
      ...
    }:
    {
      xdg = {
        enable = true;
        userDirs = {
          enable = true;
          createDirectories = false;
        };

        portal = {
          enable = true;

          extraPortals = [
            pkgs.xdg-desktop-portal-gtk
            pkgs.xdg-desktop-portal-gnome
          ];

          config.niri = {
            default = [
              "gnome"
              "gtk"
            ];
            "org.freedesktop.impl.portal.Access" = [ "gtk" ];
            "org.freedesktop.impl.portal.Notification" = [ "gtk" ];
            "org.freedesktop.impl.portal.Secret" = [ "gnome-keyring" ];
          };

        };
      };

      home.file = {
        "Documents".source = config.lib.file.mkOutOfStoreSymlink "${userconf.cloud}/Documents";
        "Development".source = config.lib.file.mkOutOfStoreSymlink "${userconf.cloud}/Development";
        "Pictures".source = config.lib.file.mkOutOfStoreSymlink "${userconf.cloud}/Pictures";
        "Videos".source = config.lib.file.mkOutOfStoreSymlink "${userconf.cloud}/Videos";
      };
    };
}
