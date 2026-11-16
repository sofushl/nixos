# Copyright (C) 2026 Sofus Højberg Lind
# SPDX-License-Identifier: AGPL-3.0-or-later

{ self, ... }: {
  flake.homeModules.niriMin = { pkgs, ... }: {
    imports = with self.homeModules; [
      base
      environment
      user
      xdg
      niri
      mimeapps
      vesktop

      kitty
      browser
      neovim
      yazi
      git
      claude
      opencode
      bitwarden

      bash
      fonts
      fastfetch

      {
        home.packages = with pkgs; [
          spotify
          element-desktop
          vlc
          loupe
        ];
      }
    ];
  };
}
