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
        darkmode
        develop

        # Services
        eduroam
        greetd-niri
        keyd

        # Programs
        vscodium
        neovim
        git
        librewolf
        nextcloudClient
      ];

      boot.loader = {
        systemd-boot.enable = true;
        efi.canTouchEfiVariables = true;
      };

      system.stateVersion = userconf.state;

      powerManagement.cpuFreqGovernor = "powersave";
    };
}
