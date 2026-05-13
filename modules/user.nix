{ self, inputs, ... }:

{
  flake.nixosModules.user =

    {
      userconf,
      config,
      ...
    }:
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

      users.users.root.initialPassword = userconf.pin;
    };
}
