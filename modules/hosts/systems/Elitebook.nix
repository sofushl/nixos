# Copyright (C) 2026 Sofus Højberg Lind
# SPDX-License-Identifier: AGPL-3.0-or-later

{ self, ... }:

{
  flake.nixosModules.Elitebook = { pkgs, userconf, ... }: {
    imports = with self.nixosModules; [
      base
      environment
      hardware
      home
      user
      disko
      preservation
      lanzaboote

      audio
      niri

      gaming
      fingerprint

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

    environment.systemPackages = with pkgs; [
      blender
      prusa-slicer
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

}
