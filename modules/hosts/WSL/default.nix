{ self, inputs, ... }:
let
  userconf = import ../../../lib/sofushl.nix;
  wslconf = import ../../../lib/WSL.nix;
  sshkeys = import ../../../lib/sshkeys.nix;
  secrets = import /etc/nixos/secrets.nix;
  default = userconf // sshkeys // secrets;

  defaultModules = [

    inputs.home-manager.nixosModules.home-manager
    { home-manager.useGlobalPkgs = true; }
  ];
in

{
  flake.nixosConfigurations.WSL = inputs.nixpkgs.lib.nixosSystem {
    system = "x86_64-linux";

    specialArgs = {
      inherit inputs;
      userconf = default // wslconf;
    };

    modules =
      with self.nixosModules;
      [
        WSLConfiguration
      ]
      ++ defaultModules;
  };
}
