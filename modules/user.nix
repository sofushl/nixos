{ self, inputs, ... }: {
  flake.nixosModules.user =
    {
      userconf,
      pkgs,
      ...
    }:
    {
      imports = [ inputs.home-manager.nixosModules.home-manager ];

      home-manager = {
        useGlobalPkgs = false;
        useUserPackages = true;
        backupFileExtension = "back";
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
            "dialout"
          ];

          hashedPassword = userconf.pinhash;

          openssh.authorizedKeys.keys = userconf.sshkeys;
        };

        mutableUsers = false;
      };
    };

  flake.homeModules.user =
    {
      userconf,
      ...
    }:
    {
      imports = [ self.homeModules.stylix ];

      nixpkgs.config.allowUnfree = true;

      home = {
        username = userconf.username;
        stateVersion = userconf.state;
        homeDirectory = "/home/${userconf.username}";
      };

      programs.nh = {
        enable = true;
        flake = "/${userconf.path}";

        clean = {
          enable = true;
        };
      };

    };
}
