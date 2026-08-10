{ self, ... }:
{
  flake.nixosConfigurations.init = self.inputs.nixpkgs.lib.nixosSystem {
    specialArgs.userconf.disk = "sda";
    modules = [
      self.nixosModules.disko
      {
        nixpkgs.hostPlatform = "x86_64-linux";
        boot.loader.systemd-boot.enable = true;
        hardware.enableRedistributableFirmware = true;
        networking.networkmanager.enable = true;
        system.stateVersion = "26.11";
        users.users.root.initialPassword = "p";
      }
    ];
  };
}
