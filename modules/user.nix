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

          hashedPassword = userconf.pinhash;

          openssh.authorizedKeys.keys = userconf.sshkeys;
        };

        mutableUsers = false;

        users.root.hashedPassword = userconf.pinhash;
      };

      home-manager = {
        useGlobalPkgs = true;
        useUserPackages = true;
        extraSpecialArgs = { inherit userconf; };
        users.${userconf.username}.imports = [ ../home ];
      };

    };
}
