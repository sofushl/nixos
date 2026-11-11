# Copyright (C) 2026 Sofus Højberg Lind
# SPDX-License-Identifier: AGPL-3.0-or-later

{ inputs, ... }:
{
  flake.nixosModules.lanzaboote =
    { lib, pkgs, ... }:
    {
      imports = [ inputs.lanzaboote.nixosModules.lanzaboote ];

      boot.loader.systemd-boot.enable = lib.mkForce false;

      boot.lanzaboote = {
        enable = true;
        pkiBundle = "/var/lib/sbctl";
      };
    };
}
