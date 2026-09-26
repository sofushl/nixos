{ self, ... }: {
  flake.nixosModules.homeSetup = { userconf, pkgs, ... }: {
    home-manager.users.${userconf.username}.imports = with self.homeModules; [
      homeSetup
      opencode
    ];

    preservation.preserveAt."/persistent".users.${userconf.username}.directories = [
      ".ollama"
      ".local/share/opencode"
      ".local/state/opencode"
      ".config/opencode"
    ];

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

  };

  flake.homeModules.homeSetup = { lib, pkgs, ... }: {
    programs.niri.settings = {
      outputs = {
        "eDP-1".enable = false;

        "DP-6" = {
          position = {
            x = 0;
            y = 0;
          };
          scale = 0.8;
        };

        "DP-5".position = {
          x = 1700;
          y = 0;
        };
      };
    };
  };
}
