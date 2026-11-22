# Copyright (C) 2026 Sofus Højberg Lind
# SPDX-License-Identifier: AGPL-3.0-or-later

{ self, ... }:

{
  flake.nixosModules.Zbook = { userconf, ... }: {
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
      node
    ];

    preservation.preserveAt."/persistent" = {
      users.${userconf.username} = {
        directories = [
          ".config/Bitwarden CLI"
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

    environment.shellAliases.windows-reboot = ''
      sudo efibootmgr -n "$(efibootmgr | sed -n 's/^Boot\([0-9A-F]*\)\* Windows Boot Manager.*/\1/p')" && systemctl reboot
    '';
    time.hardwareClockInLocalTime = true;

    powerManagement.cpuFreqGovernor = "powersave";
  };

  flake.homeModules.homeMonitor = { lib, pkgs, ... }: {
    wayland.windowManager.niri.settings._children = [
      {
        output = {
          _args = [ "eDP-1" ];
          off = { };
          mode = "1920x1080";
          position._props = {
            x = 0;
            y = 0;
          };
        };
      }
      {
        output = {
          _args = [ "DP-6" ];
          mode = "1360x768";
          position._props = {
            x = 1920;
            y = 0;
          };
        };
      }
      {
        output = {
          _args = [ "DP-5" ];
          mode = "2560x1440";
          position._props = {
            x = 3280;
            y = 0;
          };
        };
      }
    ];
  };
}
