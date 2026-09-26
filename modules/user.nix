{ self, inputs, ... }: {
  flake.nixosModules.user =
    {
      userconf,
      pkgs,
      stablepkgs,
      ...
    }:
    {
      imports = [ inputs.home-manager.nixosModules.home-manager ];

      home-manager = {
        useGlobalPkgs = false;
        useUserPackages = true;
        backupFileExtension = "back";
        extraSpecialArgs = { inherit userconf inputs stablepkgs; };
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
            "plugdev"
            "input"
          ];

          hashedPasswordFile = "/var/lib/secrets/${userconf.username}.hash";

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
