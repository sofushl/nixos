# Copyright (C) 2026 Sofus Højberg Lind
# SPDX-License-Identifier: AGPL-3.0-or-later

{ self, ... }:

{
  flake.nixosModules.Aspire = { pkgs, userconf, ... }: {
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

      wifi
      openssh
      bluetooth
      keyring
      keyd

      python
      rustWASM
      clangGTK
      javaFx
    ];

    preservation.preserveAt."/persistent" = {
      users.${userconf.username} = {
        directories = [
          ".librewolf"
          ".config/vesktop/sessionData/"
          ".config/Element"
          ".config/spotify"
          ".cache/spotify"

          ".cache/rclone"

          ".config/JetBrains"
          ".local/share/JetBrains"
          ".m2"

          ".config/VSCodium"
          ".vscode-oss-shared"

          ".claude"

          ".local/share/opencode"
          ".local/state/opencode"
          ".config/opencode"
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
