{ self, inputs, ... }:

{
  flake.nixosModules.WSLConfiguration =

    { userconf, lib, ... }:

    {
      imports = with self.nixosModules; [
        base
        user
        develop
        icedDev
        javafxDev
        micropython

        inputs.nixos-wsl.nixosModules.default
      ];

      home-manager.users.${userconf.username}.imports = with self.homeModules; [
        dev
        yazi
        neovim
        fastfetch
        git
      ];

      networking.hostName = "WSL";
      networking.resolvconf.enable = lib.mkForce false;

      wsl = {
        enable = true;
        defaultUser = userconf.username;
        startMenuLaunchers = true;
      };

      system.stateVersion = userconf.state;
    };
}
