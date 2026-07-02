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
        useUserPackages = false;
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
      home = {
        username = userconf.username;
        stateVersion = userconf.state;
        homeDirectory = "/home/${userconf.username}";
        shellAliases = {
          home-switch = ''
            git -C /${userconf.path} add -A
            nix run nixpkgs#home-manager -- switch --flake /${userconf.path}#${userconf.host} -b back
          '';

          nix-clear = ''
            nix-collect-garbage -d
            nh clean all
            nix store optimise
            sudo fstrim -av
          '';

          home-pull = ''
            git -C /${userconf.path} pull
            home-build
            nix-clear
          '';
        };
      };

      programs = {
        nh = {
          enable = true;
          flake = "/${userconf.path}";

          clean = {
            enable = true;
          };
        };
        home-manager = {
          enable = true;
        };
      };
    };

}
