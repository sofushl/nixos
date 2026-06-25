{ self, ... }: {
  flake.nixosModules.user =
    {
      userconf,
      pkgs,
      ...
    }:
    {
      home-manager = {
        useGlobalPkgs = true;
        useUserPackages = true;
        extraSpecialArgs = { inherit userconf; };
        users.${userconf.username} = self.homeModules.user;
      };

      users = {
        users.${userconf.username} = {
          isNormalUser = true;
          description = userconf.displayname;

          extraGroups = [
            "wheel"
            "networkmanager"
            "storage"
          ];

          hashedPassword = userconf.pinhash;

          openssh.authorizedKeys.keys = userconf.sshkeys;
        };

        mutableUsers = false;

        users.root.hashedPassword = userconf.pinhash;
      };
    };

  flake.homeModules.user =
    {
      userconf,
      ...
    }:
    {
      home.username = userconf.username;
      home.stateVersion = userconf.state;
      home.homeDirectory = "/home/${userconf.username}";
    };
}
