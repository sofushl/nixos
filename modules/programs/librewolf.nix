{ self, inputs, ... }:

{
  flake.nixosModules.librewolf =
    { userconf, ... }:

    {
      home-manager.users.${userconf.username}.programs.librewolf = {
        enable = true;

        profiles.default = {
          settings = {
            "webgl.disabled" = false;
            "privacy.resistfingerprinting" = false;
            "firefoxsync.disabled" = false;
          };
          userChrome = ../../dotfiles/librewolf.css;

        };

      };

    };
}
