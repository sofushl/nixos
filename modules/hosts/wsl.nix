{
  self,
  inputs,
  lib,
  ...
}:
let
  homes = import ../../lib/homes.nix;
  resolvehome = builtins.mapAttrs (_: h: homes.default // h) homes.homes;
  homeconf = resolvehome.${wslconf.username};
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
          defaultUser = userconf.username;
          startMenuLaunchers = true;
        };

        home-manager.users.${userconf.username}.imports = with self.homeModules; [
          develop
        ];

        home-manager.users.${userconf.username}.dconf.enable = lib.mkForce false;
      }
    ];
  };
}
