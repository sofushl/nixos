{ self, ... }:
{
  flake.nixosConfigurations.init = self.inputs.nixpkgs.lib.nixosSystem {
    system = "x86_64-linux";
    specialArgs.userconf.disk = "nvme0n1";
    modules = with self.nixosModules; [
      base
      preservation
      disko
      {
        networking.networkmanager.enable = true;
      }
    ];
  };
}
