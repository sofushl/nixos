{ self, inputs, ... }:
let
  userconf = import ../../../lib/sofushl.nix;
  wslconf = import ../../../lib/WSL.nix;
  sshkeys = import ../../../lib/sshkeys.nix;
  secrets = import /etc/nixos/secrets.nix;
in
{
  flake.nixosConfigurations.WSL = inputs.nixpkgs.lib.nixosSystem {
    system = "x86_64-linux";

    specialArgs = {
      inherit inputs;
      userconf = userconf // wslconf // sshkeys // secrets;
    };

    modules = with self.nixosModules; [
      WSLConfiguration
    ];
  };
}
