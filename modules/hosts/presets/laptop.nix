{ self, inputs, ... }:

{
  flake.nixosModules.laptopPreset =
    { userconf, ... }:

    {
      imports = with self.nixosModules; [
        base
        desktop
        user
        preservation
        niri

        # Development libraries
        develop
        javafxDev
        icedDev

        # Services
        networkmanager
        greetd-niri
        keyd
        nextcloudClient
      ];

      home-manager.users.${userconf.username}.imports = [
        ../../../home/dev.nix
        ../../../home/git.nix
        ../../../home/yazi.nix
        ../../../home/neovim.nix
        ../../../home/fastfetch.nix
        ../../../home/wezterm.nix
        ../../../home/firefox.nix
      ];

      preservation.preserveAt."/persistent".users.${userconf.username}.directories = [
        ".config/mozilla"
      ];

      boot.loader = {
        systemd-boot.enable = true;
        systemd-boot.configurationLimit = 10;
        efi.canTouchEfiVariables = true;
      };

      system.stateVersion = userconf.state;

      powerManagement.cpuFreqGovernor = "powersave";
    };
}
