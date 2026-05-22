{ self, inputs, ... }:
let
  userconf = import ../../../lib/sofushl.nix;
  sysconf = import ../../../lib/PNY.nix;
  sshkeys = import ../../../lib/sshkeys.nix;
  secrets = import /etc/nixos/secrets.nix;
in
{
  flake.nixosConfigurations.PNY = inputs.nixpkgs.lib.nixosSystem {
    system = "x86_64-linux";

    specialArgs = {
      inherit inputs;
      userconf = userconf // sysconf // sshkeys // secrets;
    };

    networking.hostName = "PNY";

    modules = with self.nixosModules; [
      ventoyDisk

      usbPreset

      inputs.home-manager.nixosModules.home-manager
      { home-manager.useGlobalPkgs = true; }
      inputs.disko.nixosModules.disko
      inputs.preservation.nixosModules.default

    ];
  };
}
