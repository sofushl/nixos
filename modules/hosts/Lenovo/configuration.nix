{ self, inputs, ... }:
let
  userconf = import ../../../lib/sofushl.nix;
  sysconf = import ../../../lib/Lenovo.nix;
  sshkeys = import ../../../lib/sshkeys.nix;
  secrets =
    if builtins.pathExists /etc/nixos/secrets.nix then import ../../../lib/sshkeys.nix else { };
in
{
  flake.nixosConfigurations.Lenovo = inputs.nixpkgs.lib.nixosSystem {
    system = "x86_64-linux";

    specialArgs = {
      inherit inputs;
      userconf = userconf // sysconf // sshkeys // secrets;
    };

    modules = with self.nixosModules; [
      LenovoHardware
      initPreset
    ];
  };
}
