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

      python
      rustWASM
      clangGTK
      mplab
    ];

    home-manager.users.${userconf.username}.imports = with self.homeModules; [
      base
      environment
      user
      desktop
      niri

      kitty
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
          spotify
          discord
          element-desktop
          onlyoffice-desktopeditors
          wl-clicker

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

          ".mplab"
          ".mplabcomm"
          ".mchp_packs"

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
