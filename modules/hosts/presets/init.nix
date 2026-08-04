{ self, ... }:

{
  flake.nixosModules.initPreset =
    { userconf, ... }:

    {
      imports = with self.nixosModules; [
        base
        user
        disko
        preservation
      ];

      networking.networkmanager.enable = true;

      boot.loader = {
        systemd-boot.enable = true;
        efi.canTouchEfiVariables = true;
      };
    };
}
