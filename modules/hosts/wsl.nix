{ self, inputs, ... }:
let
  homes = import ../../lib/homes.nix;
  resolvehome = builtins.mapAttrs (_: h: homes.default // h) homes.homes;
  homeconf = resolvehome.headless;
  wslconf = import ../../lib/wsl.nix;
  sshkeys = import ../../lib/sshkeys.nix;
  theme = import ../../lib/theme.nix;
  stablepkgs = import inputs.stablepkgs {
    system = "x86_64-linux";
    config.allowUnfree = true;
    config.cudaSupport = true;
  };
in
{
  flake.nixosConfigurations.${wslconf.host} = inputs.nixpkgs.lib.nixosSystem {
    system = "x86_64-linux";

    specialArgs = {
      inherit inputs stablepkgs;
      userconf = homeconf // wslconf // theme // sshkeys;
    };

    modules = with self.nixosModules; [
      base
      environment
      user
      openssh
      keyring

      javafxlib
      electronDev
      python
      node
      rustWASM

      inputs.nixos-wsl.nixosModules.default
      {
        wsl = {
          enable = true;
          defaultUser = homeconf.username;
          startMenuLaunchers = true;
        };

        home-manager.users.${homeconf.username}.imports = with self.homeModules; [
          develop
          fonts
        ];
      }
    ];
  };
}
