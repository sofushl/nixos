{ self, inputs, ... }:
let
  userconf = import ../../../lib/sofushl.nix;
  sysconf = import ../../../lib/Lenovo.nix;
  serverconf = import ../../../lib/server.nix;
  sshkeys = import ../../../lib/sshkeys.nix;
  secrets = import /etc/nixos/secrets.nix;
in
{
  flake.nixosConfigurations.Lenovo = inputs.nixpkgs.lib.nixosSystem {
    system = "x86_64-linux";

    specialArgs = {
      inherit inputs;
      userconf = userconf // sysconf // sshkeys // secrets // serverconf;
    };

    modules = with self.nixosModules; [
      LenovoHardware
      serverPreset

    ];
  };
}
