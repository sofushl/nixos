# Copyright (C) 2026 Sofus Højberg Lind
# SPDX-License-Identifier: AGPL-3.0-or-later

{ inputs, ... }:
{
  flake.nixosModules.preservation =
    {
      userconf,
      config,
      lib,
      ...
    }:
    {

      imports = [ inputs.preservation.nixosModules.default ];

      preservation.enable = true;

      zramSwap = {
        enable = true;
        algorithm = "zstd";
        memoryPercent = 20;
        priority = 2;
      };

      swapDevices = [
        {
          device = "/persistent/swapfile";
          size = 16 * 1024;
          priority = 1;
        }
      ];

      preservation.preserveAt."/persistent" = {
        directories = [
          {
            directory = "/var/lib";
            inInitrd = true;
          }
          "/etc/ssh"
        ]
        ++ lib.optional config.networking.networkmanager.enable "/etc/NetworkManager";

        files = [
          {
            file = "/etc/machine-id";
            inInitrd = true;
          }
        ];

        users.${userconf.username} = {
          directories = [
            "Library"
            "Downloads"
            "nixos"
            ".ssh"
            ".local/share/keyrings"
            ".config/Bitwarden CLI"
          ];

          files = [
            ".bash_history"
          ];
        };
      };
    };
}
