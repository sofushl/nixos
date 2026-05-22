{ self, inputs, ... }:

{
  flake.nixosModules.usbPreset =

    { userconf, ... }:

    {
      imports = with self.nixosModules; [
        base
        user

        # Programs
        networkmanager
        neovim
        git
      ];

      boot.loader = {
        systemd-boot.enable = true;
        efi.canTouchEfiVariables = true;
      };

      system.stateVersion = userconf.state;

      powerManagement.cpuFreqGovernor = "powersave";
    };
}
