{ self, inputs, ... }:

{
  flake.nixosModules.laptopPreset =
    { userconf, ... }:

    {
      imports = with self.nixosModules; [
        base
        desktop
        user

        niri
        develop
        preservation

        # Services
        networkmanager
        greetd-niri
        keyd

        # Programs
        wezterm
        neovim
        yazi
        git
        firefox
        nextcloudClient
        fastfetch
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
