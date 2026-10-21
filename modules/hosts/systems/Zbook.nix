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
      desktop

      niri
      gaming
      nvidia

      eduroam
      openssh
      bluetooth
      keyring
      keyd
      docker

      python
      rustWASM
      clangGTK
      mplab
    ];

    preservation.preserveAt."/persistent" = {
      directories = [ "opt" ];
      users.${userconf.username} = {
        directories = [
          "Downloads"
          "Documents"
          "Public"
          "Cloud"

          ".librewolf"
          ".config/discord"
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

          ".mplab"
          ".mplabcomm"
          ".mchp_packs"

          ".claude"

          ".ollama"
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
        ];
      };
    };

    powerManagement.cpuFreqGovernor = "powersave";
  };

  flake.homeModules.homeMonitor = { lib, pkgs, ... }: {
    programs.niri.settings = {
      outputs = {
        "eDP-1".enable = false;

        "DP-6" = {
          mode = {
            width = 1360;
            height = 768;
            refresh = 60.015;
          };
          position = {
            x = 0;
            y = 0;
          };
        };

        "DP-5" = {
          mode = {
            width = 2560;
            height = 1440;
            refresh = 59.951;
          };
          position = {
            x = 1360;
            y = 0;
          };
        };
      };
    };
  };
}
