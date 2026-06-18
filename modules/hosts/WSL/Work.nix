{ self, inputs, ... }:
let
  userconf = import ../../../lib/sofushl.nix;
  wslconf = import ../../../lib/WSLWork.nix;
  sshkeys = import ../../../lib/sshkeys.nix;
in
{
  flake.nixosConfigurations.WSLWork = inputs.nixpkgs.lib.nixosSystem {
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
