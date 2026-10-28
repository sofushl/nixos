{
  flake.homeModules.git =
    {
      userconf,
      pkgs,
      lib,
      ...
    }:

    # REQUIRES PERSISTENT "./config/gh/hosts.yml"

    {

      programs = {
        git = {
          enable = true;

          settings = {
            commit.gpgsign = true;
            tag.gpgsign = true;
            gpg.format = "ssh";

            user = {
              name = userconf.displayname;
              email = userconf.gitmail;
              signingkey = "~/.ssh/id_ed25519.pub";
            };

            url = {
              "https://github.com/" = {
                insteadOf = [
                  "gh:"
                  "github:"
                ];
              };
              "https://github.com/sofushl/" = {
                insteadOf = [
                  "shl:"
                ];
              };
              "https://codeberg.org/" = {
                insteadOf = [
                  "cb:"
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
              filter-repo = "!${lib.getExe pkgs.git-filter-repo}";
            };
          };
        };

        delta = {
          enable = true;
          enableGitIntegration = true;
        };

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
        "pull" = "git pull";
        "push" = "git push";

        "git-local" = ''
          git config --local user.name "${userconf.localgitname}" && \
          git config --local user.email "${userconf.localgitmail}"
        '';
      };
    };
}
