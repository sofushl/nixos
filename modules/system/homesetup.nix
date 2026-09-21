{ self, ... }: {
  flake.nixosModules.homeSetup = { userconf, ... }: {
    home-manager.users.${userconf.username}.imports = with self.homeModules; [
      homeSetup
    ];

  };

  flake.homeModules.homeSetup = { lib, pkgs, ... }: {
    programs.niri.settings = {
      outputs = {
        "eDP-1".enable = false;

        "DP-6" = {
          position = {
            x = 0;
            y = 0;
          };
          scale = 0.8;
        };

        "DP-5".position = {
          x = 1700;
          y = 0;
        };
      };
    };
  };
}
