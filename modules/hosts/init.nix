{ inputs, self, ... }:
{
  flake.nixosConfigurations.init = inputs.nixpkgs.lib.nixosSystem {
    system = "x86_64-linux";

    specialArgs = {
      inherit inputs;
      userconf = {
        disk = "sda";
      };
    };

    modules = with self.nixosModules; [
      disko
      {
        boot.loader = {
          systemd-boot.enable = true;
          efi.canTouchEfiVariables = true;
        };

        hardware.enableRedistributableFirmware = true;

        networking.hostName = "nixos";
        system.stateVersion = "26.11";

        users.users.root.initialPassword = "p";

        networking.networkmanager.enable = true;
      }
    ];
  };
}
