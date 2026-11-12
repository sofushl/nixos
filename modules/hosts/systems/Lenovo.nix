# Copyright (C) 2026 Sofus Højberg Lind
# SPDX-License-Identifier: AGPL-3.0-or-later

{ self, ... }:

{
  flake.nixosModules.Lenovo = { pkgs, userconf, ... }: {
    imports = with self.nixosModules; [
      base
      environment
      hardware
      user
      disko
      preservation
      lanzaboote

      niri
      audio
      home

      wifi
      openssh
      keyd
    ];

    preservation.preserveAt."/persistent" = {
      directories = [ "opt" ];
      users.${userconf.username} = {
        directories = [
          ".librewolf"
          ".config/vesktop"
          ".config/Element"
          ".config/spotify"
          ".cache/spotify"

          ".local/state/wireplumber"

          ".local/share/opencode"
          ".local/state/opencode"
          ".config/opencode"

          ".claude"
        ];

        files = [
          ".config/gh/hosts.yml"
          ".claude.json"
          ".npmrc"
        ];
      };
    };

    powerManagement.cpuFreqGovernor = "powersave";
  };

}
