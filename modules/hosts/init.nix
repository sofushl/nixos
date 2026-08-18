{ self, ... }:
{
  flake.nixosConfigurations.init = self.inputs.nixpkgs.lib.nixosSystem {
    specialArgs.userconf.disk = "sda";
    modules = [
      self.nixosModules.disko
    ];
  };
}
