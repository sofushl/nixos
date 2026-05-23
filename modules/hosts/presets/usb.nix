{ self, inputs, ... }:

{
  flake.nixosModules.usbPreset =

    { userconf, lib, ... }:

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

      networking.hostName = lib.mkDefault "USB";
      system.stateVersion = userconf.state;

      powerManagement.cpuFreqGovernor = "powersave";
    };
}
