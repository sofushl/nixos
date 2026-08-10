{ self, inputs, ... }:
let
  userconf = import ../../lib/sofushl.nix;
  wslconf = import ../../lib/wsl.nix;
  sshkeys = import ../../lib/sshkeys.nix;
in
{
  flake.nixosConfigurations.${wslconf.host} = inputs.nixpkgs.lib.nixosSystem {
    system = "x86_64-linux";

    specialArgs = {
      inherit inputs;
      userconf = userconf // wslconf // sshkeys;
    };

    modules = with self.nixosModules; [
      base
      user
      develop
      openssh

      icedDev
      javafxDev
      micropython

      inputs.nixos-wsl.nixosModules.default

      {
        environment.systemPackages = with pkgs; [
          kmod
        ];

        networking.resolvconf.enable = lib.mkForce false;

        wsl = {
          enable = true;
          defaultUser = userconf.username;
          startMenuLaunchers = true;
        };
      }
    ];
  };
}
