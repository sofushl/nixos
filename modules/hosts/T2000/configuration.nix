{ self, inputs, ... }:
let
  userconf = import ../../../lib/sofushl.nix;
  sysconf = import ../../../lib/T2000.nix;
  pkgs = inputs.nixpkgs.legacyPackages."x86_64-linux";
  serverconf = import ../../../lib/server.nix { inherit pkgs; };
  sshkeys = import ../../../lib/sshkeys.nix;
  secrets = import /etc/nixos/secrets.nix;
in
{
  flake.nixosConfigurations.T2000 = inputs.nixpkgs.lib.nixosSystem {
    system = "x86_64-linux";

    specialArgs = {
      inherit inputs;
      userconf = userconf // sysconf // sshkeys // secrets // serverconf;
    };

    modules = with self.nixosModules; [
      T2000Hardware
      nvidia
      serverPreset
    ];
  };
}
