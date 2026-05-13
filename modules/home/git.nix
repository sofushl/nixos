{ self, inputs, ... }:

{
  flake.nixosModules.git =
    { userconf, ... }:

    {
      home-manager.users.${userconf.username}.programs.git = {
        enable = true;

        settings = {

          user = {
            name = userconf.displayname;
            email = userconf.gitmail;
          };

          init.defaultBranch = "main";
          pull.rebase = true;
          core.editor = "nvim";
        };
      };

    };
}
