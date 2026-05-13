{ self, inputs, ... }:

{
  flake.nixosModules.git =
    { userconf, ... }:

    {
      home-manager.users.${userconf.username}.programs.git = {
        enable = true;

        settings = {
          init.defaultBranch = "main";
          pull.rebase = true;
          core.editor = "nvim";
        };
      };

    };
}
