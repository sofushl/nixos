{ self, inputs, ... }:

{
  flake.nixosModules.user =
    { userconf, config, ... }:
    {
      users.users.${userconf.username} = {
        isNormalUser = true;
        description = userconf.displayname;

        extraGroups = [
          "wheel"
          "networkmanager"
        ];

        initialPassword = userconf.pin;

        openssh.authorizedKeys.keys = userconf.sshkeys;
      };

      home-manager.users.${userconf.username} = {

        home.username = userconf.username;
        home.stateVersion = userconf.state;
        home.homeDirectory = "/home/${userconf.username}";
      };

      users.users.root.initialPassword = userconf.pin;
    };
}
