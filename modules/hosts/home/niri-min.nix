# Copyright (C) 2026 Sofus Højberg Lind
# SPDX-License-Identifier: AGPL-3.0-or-later

{ self, ... }: {
  flake.homeModules.niriMin = { ... }: {
    imports = with self.homeModules; [
      base
      environment
      user
      niri
      mimeapps

      bash
      vesktop
      element
      fastfetch
      kitty
      browser
      neovim
      yazi
      git
      claude
      opencode
      bitwarden
      rclone
    ];
  };
}
