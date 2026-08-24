{
  self,
  inputs,
  lib,
  ...
}:
let
  userconf = import ../../lib/sofushl.nix;
  wslconf = import ../../lib/wsl.nix;
  sshkeys = import ../../lib/sshkeys.nix;
  theme = import ../../lib/theme.nix;
in
{
  flake.nixosConfigurations.${wslconf.host} = inputs.nixpkgs.lib.nixosSystem {
    system = "x86_64-linux";

    specialArgs = {
      inherit inputs;
      userconf = userconf // wslconf // theme // sshkeys;
    };

    modules = with self.nixosModules; [
      base
      user
      develop
      openssh

      icedDev
      javafxlib
      micropython

      inputs.nixos-wsl.nixosModules.default

      {
        wsl = {
          enable = true;
          defaultUser = userconf.username;
          startMenuLaunchers = true;
        };

        home-manager.users.${userconf.username}.dconf.enable = lib.mkForce false;
      }
    ];
  };
}
