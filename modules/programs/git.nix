{
  flake.homeModules.git = { userconf, ... }: {
    programs = {
      git = {
        enable = true;

        settings = {

          user = {
            name = userconf.displayname;
            email = userconf.gitmail;
          };

          url = {
            "https://github.com/" = {
              insteadOf = [
                "gh:"
                "github:"
              ];
            };
          };

          init.defaultBranch = "main";
          pull.rebase = true;
          core.editor = "nvim";

          alias = {
            ci = "commit";
            co = "checkout";
            stat = "status";
            res = "restore";
          };
        };
      };

      # REQUIRES PERSISTENT "./config/gh/hosts.yml"

      gh = {
        enable = true;

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
    };

    home.shellAliases = {
      "push" = "git push";
      "stash" = "git stash";
      "pop" = "git stash pop";
      "pull" = "git pull";
      "diff" = "git diff";

      "git-local" = ''
        git config --local user.name "${userconf.localgitname}" && \
        git config --local user.email "${userconf.localgitmail}"
      '';
    };
  };
}
