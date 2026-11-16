# Copyright (C) 2026 Sofus Højberg Lind
# SPDX-License-Identifier: AGPL-3.0-or-later

{ self, inputs, ... }:
{
  flake.nixosModules.WSL = { userconf, ... }: {
    imports = with self.nixosModules; [
      base
      environment
      user
      home
      openssh
      keyring

      electronDev
      python
      rustWASM

      inputs.nixos-wsl.nixosModules.default
    ];

    wsl = {
      enable = true;
      defaultUser = userconf.username;
      startMenuLaunchers = true;
    };
  };
}
