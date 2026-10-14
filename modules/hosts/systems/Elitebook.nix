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

      desktop
      niri

      gaming
      fingerprint

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
          "Documents"
          "Downloads"
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

}
