{
  self,
  inputs,
  ...
}:
let
  system = "x86_64-linux";
  pkgs = import inputs.nixpkgs {
    inherit system;
    config.allowUnfree = true;
  };
  homes = import ../../lib/homes.nix;
  resolvehome = builtins.mapAttrs (_: h: homes.default // h) homes.homes;

  sshkeys = import ../../lib/sshkeys.nix;
  theme = import ../../lib/theme.nix;
in
{
  flake.homeConfigurations = builtins.mapAttrs (
    type: homeconf:
    inputs.home-manager.lib.homeManagerConfiguration {
      inherit pkgs;

      extraSpecialArgs = {
        inherit inputs;
        userconf = homeconf // theme // sshkeys;
      };

      modules =
        with self.homeModules;
        [
          base
          environment
          user
          kitty
          niri
          desktop
          develop
          firefox
        ]
        ++ map (n: self.homeModules.${n}) homeconf.modules;
    }
  ) resolvehome;
}
