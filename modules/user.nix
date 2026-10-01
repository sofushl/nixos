{ inputs, ... }:

# REQUIRES HOME AND NIXOS IMPORT "user"

{
  flake.nixosModules.user =
    {
      userconf,
      pkgs,
      stablepkgs,
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
            "dialout"
            "plugdev"
            "input"
            "minecraft"
          ];

          hashedPasswordFile = "/var/lib/secrets/${userconf.username}.hash";

          openssh.authorizedKeys.keys = userconf.sshkeys;
        };

        mutableUsers = false;
      };
    };

  flake.nixosModules.home = { userconf, stablepkgs, ... }: {

    imports = [ inputs.home-manager.nixosModules.home-manager ];

    home-manager = {
      useGlobalPkgs = false;
      useUserPackages = true;
      backupFileExtension = "back";
      extraSpecialArgs = { inherit userconf inputs stablepkgs; };
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
