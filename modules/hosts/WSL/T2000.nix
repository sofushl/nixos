{ self, inputs, ... }:
let
  userconf = import ../../../lib/sofushl.nix;
  wslconf = import ../../../lib/WSLT2000.nix;
  sshkeys = import ../../../lib/sshkeys.nix;
in
{
  flake.nixosConfigurations.WSLT2000 = inputs.nixpkgs.lib.nixosSystem {
    system = "x86_64-linux";

    specialArgs = {
      inherit inputs;
      userconf = userconf // wslconf // sshkeys;
    };

    modules = with self.nixosModules; [
      WSLConfiguration
    ];
  };
}
