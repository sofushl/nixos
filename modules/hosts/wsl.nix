{
  self,
  inputs,
  lib,
  ...
}:
let
  homes = import ../../lib/homes.nix;
  resolvehome = builtins.mapAttrs (_: h: homes.default // h) homes.homes;
  homeconf = resolvehome.headless;
  wslconf = import ../../lib/wsl.nix;
  sshkeys = import ../../lib/sshkeys.nix;
  theme = import ../../lib/theme.nix;
in
{
  flake.nixosConfigurations.${wslconf.host} = inputs.nixpkgs.lib.nixosSystem {
    system = "x86_64-linux";

    specialArgs = {
      inherit inputs;
      userconf = homeconf // wslconf // theme // sshkeys;
    };

    modules = with self.nixosModules; [
      base
      environment
      user
      openssh

      icedDev
      javafxlib
      electron
      python
      node
      rust
      c

      inputs.nixos-wsl.nixosModules.default
      {
        wsl = {
          enable = true;
          defaultUser = homeconf.username;
          startMenuLaunchers = true;
        };

        home-manager.users.${homeconf.headless}.imports = with self.homeModules; [
          headless
        ];
      }
    ];
  };

  flake.homeModules.headless = {
    dconf.enable = lib.mkForce false;
    imports = [ self.homeModules.develop ];
  };
}
