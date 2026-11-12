# Copyright (C) 2026 Sofus Højberg Lind
# SPDX-License-Identifier: AGPL-3.0-or-later

{ self, ... }:

{
  flake.nixosModules.Zbook = { pkgs, userconf, ... }: {
    imports = with self.nixosModules; [
      base
      environment
      hardware
      home
      user
      disko
      preservation
      audio
      lanzaboote

      niri
      gaming
      nvidia

      wifi
      openssh
      bluetooth
      keyring
      keyd
      docker

      python
      rustWASM
      clangGTK
      javaFx
    ];

    preservation.preserveAt."/persistent" = {
      users.${userconf.username} = {
        directories = [
          ".librewolf"
          ".config/vesktop"
          ".config/Element"
          ".config/spotify"
          ".cache/spotify"

          ".local/state/wireplumber"

          ".cache/rclone"

          ".config/libreoffice"

          ".config/JetBrains"
          ".local/share/JetBrains"
          ".m2"

          ".config/VSCodium"
          ".vscode-oss-shared"

          ".claude"

          ".local/share/opencode"
          ".local/state/opencode"
          ".config/opencode"

          ".cursor"
          ".config/Cursor"
          ".config/cursor"
          ".local/share/docker"
        ];

        files = [
          ".config/gh/hosts.yml"
          ".config/rclone/nextcloud.pass"
          ".claude.json"
          ".npmrc"
        ];
      };
    };

    powerManagement.cpuFreqGovernor = "powersave";
  };

  flake.homeModules.homeMonitor = { lib, pkgs, ... }: {
    programs.niri.settings = {
      outputs = {
        "eDP-1" = {
          enable = false;
          mode = {
            width = 1920;
            height = 1080;
          };
          position = {
            x = 0;
            y = 0;
          };
        };

        "DP-6" = {
          mode = {
            width = 1360;
            height = 768;
          };
          position = {
            x = 1920;
            y = 0;
          };
        };

        "DP-5" = {
          mode = {
            width = 2560;
            height = 1440;
          };
          position = {
            x = 3280;
            y = 0;
          };
        };
      };
    };
  };
}
