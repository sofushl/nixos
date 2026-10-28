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
      home.file.".ssh/allowed_signers".text = ''
        ${userconf.gitmail} namespaces="git" ${userconf.key}
      '';

      programs = {
        git = {
          enable = true;

          settings = {
            commit.gpgsign = true;
            tag.gpgsign = true;
            gpg.format = "ssh";
            gpg.ssh.allowedSignersFile = "~/.ssh/allowed_signers";

            user = {
              name = userconf.displayname;
              email = userconf.gitmail;
              signingkey = userconf.key;
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
