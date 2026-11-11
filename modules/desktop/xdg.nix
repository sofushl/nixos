# Copyright (C) 2026 Sofus Højberg Lind
# SPDX-License-Identifier: AGPL-3.0-or-later

{
  flake.homeModules.xdg =
    { config, userconf, ... }:
    {
      xdg = {
        enable = true;
        userDirs = {
          enable = true;
          createDirectories = false;
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
