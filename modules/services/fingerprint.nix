# Copyright (C) 2026 Sofus Højberg Lind
# SPDX-License-Identifier: AGPL-3.0-or-later

{
  flake.nixosModules.fingerprint =
    { userconf, pkgs, ... }:
    {
      services.fprintd.enable = true;
      security.pam.services.hyprlock.fprintAuth = false;
    };

  flake.homeModules.fingerprint =
    { ... }:
    {
      programs.hyprlock.settings.auth.fingerprint = {
        enabled = true;
        ready_message = "Scan fingerprint";
        present_message = "Scanning…";
        retry_delay = 250;
      };
    };
}
