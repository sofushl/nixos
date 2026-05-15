{ self, inputs, ... }:
let
  userconf = import ../../../lib/sofushl.nix;
  sysconf = import ../../../lib/Acer.nix;
  sshkeys = import ../../../lib/sshkeys.nix;
  secrets = import /etc/nixos/secrets.nix;
  default = userconf // sysconf // sshkeys // secrets;

  defaultModules = [

    inputs.home-manager.nixosModules.home-manager
    { home-manager.useGlobalPkgs = true; }
  ];
in

{
  flake.nixosConfigurations.Acer = inputs.nixpkgs.lib.nixosSystem {
    system = "x86_64-linux";

    specialArgs = {
      inherit inputs;
      userconf = default;
    };

    modules =
      with self.nixosModules;
      [
        AcerHardware
        laptopPreset
      ]
      ++ defaultModules;
  };

}
