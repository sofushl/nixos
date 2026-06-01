{ self, inputs, ... }:

{
  flake.nixosModules.user =
    {
      userconf,
      config,
      pkgs,
      ...
    }:
    {
      users = {
        users.${userconf.username} = {
          isNormalUser = true;
          description = userconf.displayname;

          extraGroups = [
            "wheel"
            "networkmanager"
            "storage"
          ];

          initialPassword = userconf.pin;

          openssh.authorizedKeys.keys = userconf.sshkeys;
        };

        users.root.initialPassword = userconf.pin;
      };

      home-manager.users.${userconf.username} = {

        home.username = userconf.username;
        home.stateVersion = userconf.state;
        home.homeDirectory = "/home/${userconf.username}";
      };

    };
}
