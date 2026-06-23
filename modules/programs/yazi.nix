{ self, inputs, ... }:

{
  flake.nixosModules.yazi =
    { userconf, pkgs, ... }:

    {
      home-manager.users.${userconf.username}.programs = {
        yazi = {
          enable = true;
          enableBashIntegration = true;

          settings = {
            log = {
              enabled = true;
            };
            mgr = {
              show_hidden = false;
              sort_by = "mtime";
              sort_dir_first = true;
              sort_reverse = false;
            };
            bash.enable = true;
          };
        };
      };

      nix.settings = {
        extra-substituters = [ "https://yazi.cachix.org" ];
        extra-trusted-public-keys = [ "yazi.cachix.org-1:Dcdz63NZKfvUCbDGngQDAZq6kOroIrFoyO064uvLh8k=" ];
      };

    };
}
