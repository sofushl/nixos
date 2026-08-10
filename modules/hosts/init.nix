{ inputs, self, ... }:
let
  userconf = import ../../lib/sofushl.nix;
  sysconf = (import ../../lib/laptops.nix).default;
in
{
  flake.nixosConfigurations.init = inputs.nixpkgs.lib.nixosSystem {
    system = "x86_64-linux";

    specialArgs = {
      inherit inputs;
      userconf = userconf // sysconf;
    };

    modules = with self.nixosModules; [
      base
      user
      disko
      preservation
      hardware
    ];

    networking.networkmanager.enable = true;
  };
}
