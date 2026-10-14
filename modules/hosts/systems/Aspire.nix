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
      desktop
      niri

      eduroam
      openssh
      bluetooth
      keyring
      keyd

      python
      rustWASM
      clangGTK
    ];

    preservation.preserveAt."/persistent" = {
      directories = [ "opt" ];
      users.${userconf.username} = {
        directories = [
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

          ".config/JetBrains"
          ".local/share/JetBrains"
          ".m2"

          ".config/VSCodium"
          ".vscode-oss-shared"

          ".claude"
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
