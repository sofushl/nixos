# Copyright (C) 2026 Sofus Højberg Lind
# SPDX-License-Identifier: AGPL-3.0-or-later

{
  flake.homeModules.obsidian = {
    programs.obsidian = {
      enable = true;
      cli.enable = true;
      vaults.NTNU = {
        target = "Cloud/NTNU";
      };
    };
  };
}
