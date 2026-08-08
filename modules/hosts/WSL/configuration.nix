{ self, inputs, ... }:

{
  flake.nixosModules.wsl =

    {
      userconf,
      lib,
      pkgs,
      ...
    }:

    {
      imports = with self.nixosModules; [
        default

        icedDev
        javafxDev
        micropython

        inputs.nixos-wsl.nixosModules.default
      ];

      environment.systemPackages = with pkgs; [
        kmod
      ];

      networking.resolvconf.enable = lib.mkForce false;

      wsl = {
        enable = true;
        defaultUser = userconf.username;
        startMenuLaunchers = true;
      };
    };
}
