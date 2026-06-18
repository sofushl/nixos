{ self, inputs, ... }:

{
  flake.nixosModules.git =
    { userconf, ... }:

    {
      home-manager.users.${userconf.username} = {
        programs = {

          git = {
            enable = true;

            #signing = {
            #  key = userconf.sshkey;
            #  signByDefault = true;
            #};

            settings = {

              user = {
                name = userconf.displayname;
                email = userconf.gitmail;
              };

              gpg.format = "ssh";
              init.defaultBranch = "main";
              pull.rebase = true;
              core.editor = "nvim";

              alias = {
                ci = "commit";
                co = "checkout";
                s = "status";
              };
            };

          };

          gh = {
            enable = true;

            hosts."github.com" = {
              user = userconf.ghname;
            };

            settings = {
              git_protocol = "ssh";

              prompt = "enabled";

              aliases = {
                co = "pr checkout";
                pv = "pr view";
              };

              editor = "nvim";
            };

          };

          ssh = {
            enable = true;

            enableDefaultConfig = false;

            settings."*".addKeysToAgent = "yes";
          };

        };
      };
    };
}
