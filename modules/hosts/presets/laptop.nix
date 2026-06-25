{ self, ... }:

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

      home-manager.users.${userconf.username}.imports = with self.homeModules; [
        dev
        git
        yazi
        neovim
        fastfetch
        wezterm
        firefox
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
