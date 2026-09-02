{ self, ... }:
{
  flake.nixosConfigurations.init = self.inputs.nixpkgs.lib.nixosSystem {
    system = "x86_64-linux";
    specialArgs.userconf.disk = "nvme0n1";
    modules = with self.nixosModules; [
      disko
      {
        networking.networkmanager.enable = true;
        users.users.root.initialPassword = "p";
        boot.loader = {
          systemd-boot.enable = true;
          systemd-boot.configurationLimit = 3;
          efi.canTouchEfiVariables = true;
        };
      }
    ];
  };
}
