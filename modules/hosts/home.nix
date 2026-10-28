{ self, inputs, ... }:
let
  system = "x86_64-linux";
  nixpkgs = import inputs.nixpkgs {
    inherit system;
    config.allowUnfree = true;
  };
  pkgs = nixpkgs;
  homes = import ../../lib/homes.nix;
  resolvehome = builtins.mapAttrs (_: h: homes.default // h) homes.homes;
  stablepkgs = import inputs.stablepkgs {
    system = pkgs.stdenv.hostPlatform.system;
    config.allowUnfree = true;
    config.cudaSupport = true;
  };
  sshkeys = import ../../lib/sshkeys.nix;
  theme = import ../../lib/theme.nix;
  serverconf = import ../../lib/server.nix { inherit nixpkgs stablepkgs; };
in
{
  flake.homeConfigurations = builtins.mapAttrs (
    type: homeconf:
    inputs.home-manager.lib.homeManagerConfiguration {
      inherit pkgs;

      extraSpecialArgs = {
        inherit inputs stablepkgs;
        userconf = homeconf // theme // sshkeys // serverconf;
      };

      modules = [ self.homeModules.${homeconf.type} ];
    }
  ) resolvehome;
}
