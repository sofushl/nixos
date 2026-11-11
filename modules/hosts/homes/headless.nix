# Copyright (C) 2026 Sofus Højberg Lind
# SPDX-License-Identifier: AGPL-3.0-or-later

{ self, ... }: {
  flake.homeModules.headless = {
    imports = with self.homeModules; [
      base
      environment
      user

      bitwarden
      docker
      neovim
      yazi
      claude
      opencode
      git
      bash
      fastfetch
    ];
  };
}
