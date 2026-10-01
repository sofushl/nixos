{ self, ... }:

{
  flake.nixosModules.Zbook = { pkgs, userconf, ... }: {
    imports = with self.nixosModules; [
      base
      environment
      hardware
      user
      disko
      preservation
      desktop

      niri
      gaming
      fingerprint
      nvidia

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
      desktop
      niri

      kitty
      firefox
      obsidian
      vscodium
      neovim
      yazi
      git

      bash
      homeMonitor
      fonts
      rclone
      fastfetch

      claude
      opencode

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

          ".ollama"
          ".local/share/opencode"
          ".local/state/opencode"
          ".config/opencode"

        ];

        files = [
          ".config/gh/hosts.yml"
          ".config/rclone/nextcloud.pass"
          ".claude.json"
        ];
      };
    };

    boot.loader.systemd-boot = {
      edk2-uefi-shell.enable = true;
      extraFiles = {
        "efi/windows/shell.efi" = "${pkgs.edk2-uefi-shell}/shell.efi";
        "efi/windows/startup.nsh" = pkgs.writeText "startup.nsh" ''
          connect -r
          map -r
          HD1b:EFI\Microsoft\Boot\Bootmgfw.efi
        '';
      };
      extraEntries."windows.conf" = ''
        title Windows
        efi /efi/windows/shell.efi
        options -nointerrupt -noversion
        sort-key o_windows
      '';
    };

    powerManagement.cpuFreqGovernor = "powersave";
  };

  flake.homeModules.homeMonitor = { lib, pkgs, ... }: {
    programs.niri.settings = {
      outputs = {
        "eDP-1".enable = false;

        "DP-6" = {
          position = {
            x = 0;
            y = 0;
          };
        };

        "DP-5".position = {
          x = 1700;
          y = 0;
        };
      };
    };
  };
}
