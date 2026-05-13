{ self, inputs, ... }:

{
  flake.nixosModules.WSLConfiguration =

    { userconf, lib, ... }:

    {
      imports =
        with self.nixosModules;
        [
          base
          user
          develop
        ]
        ++ [ <nixos-wsl/modules> ];

      home-manager.users.${userconf.username} = {

        home.username = userconf.username;
        home.stateVersion = userconf.state;
        home.homeDirectory = "/home/${userconf.username}";

        imports = [
          /${userconf.path}/home/neovim.nix
        ];

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
