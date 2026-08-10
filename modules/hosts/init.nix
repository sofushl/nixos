{ self, ... }:
{
  flake.nixosConfigurations.init = self.inputs.nixpkgs.lib.nixosSystem {
    specialArgs.userconf.disk = "sda";
    modules = [
      self.nixosModules.disko
      {
        nixpkgs.hostPlatform = "x86_64-linux";
        system.stateVersion = "26.11";

        boot.loader.systemd-boot.enable = true;
        users.users.root.initialPassword = "p";

        # networking
        networking.wireless.iwd.enable = true;
        networking.wireless.iwd.settings.General.EnableNetworkConfiguration = true;
        hardware.enableRedistributableFirmware = true; # drop if installing over ethernet

        # size trimming
        i18n.supportedLocales = [ "en_US.UTF-8/UTF-8" ];
        documentation.enable = false;
        documentation.nixos.enable = false;
        environment.defaultPackages = [ ];
        programs.command-not-found.enable = false;
      }
    ];
  };
}
