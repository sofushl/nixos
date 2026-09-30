{ self, ... }:

{
  flake.nixosModules.Aspire = { pkgs, userconf, ... }: {
    imports = with self.nixosModules; [
      base
      environment
      hardware
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

    home-manager.users.${userconf.username}.imports = with self.homeModules; [
      firefox
      obsidian
      vscodium
      neovim
      yazi
      git
      claude

      bash
      fonts
      rclone
      fastfetch

      node
      javaWithFx

      {
        home.packages = with pkgs; [
          watchmate
          siglo
          postman
          geogebra6
          krita
          inkscape
          thonny
        ];
      }

    ];

    preservation.preserveAt."/persistent" = {
      directories = [ "opt" ];
      users.${userconf.username} = {
        directories = [
          "Downloads"
          "Public"
          "Cloud"

          ".config/mozilla"
          ".config/discord"
          ".config/Element"
          ".config/spotify"
          ".cache/spotify"

          ".local/state/wireplumber"

          ".cache/rclone"

          ".config/onlyoffice"
          ".local/state/onlyoffice"

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
