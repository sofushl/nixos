# Copyright (C) 2026 Sofus Højberg Lind
# SPDX-License-Identifier: AGPL-3.0-or-later

{ self, ... }: {
  flake.homeModules.niriMax = { pkgs, ... }: {
    imports = with self.homeModules; [
      niriMin
      obsidian
      vscodium
      rclone
      bun
    ];

    home.packages = with pkgs; [
      libreoffice
      wl-clicker
      postman
      geogebra6
      krita
      inkscape
    ];
  };
}
