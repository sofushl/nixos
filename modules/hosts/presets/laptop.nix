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

        # Services
        networkmanager
        greetd-niri
        keyd

        # Programs
        ghostty
        vesktop
        vscodium
        neovim
        git
        librewolf
        nextcloudClient
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
