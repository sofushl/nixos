{ self, inputs, ... }:

{
  flake.nixosModules.WSLConfiguration =

    { userconf, lib, ... }:

    {
      imports = with self.nixosModules; [
        base
        user
        develop
        neovim
        git
        fastfetch
        inputs.nixos-wsl.nixosModules.default
      ];

      home-manager.users.${userconf.username} = {

        home.username = userconf.username;
        home.stateVersion = userconf.state;
        home.homeDirectory = "/home/${userconf.username}";
      };

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
