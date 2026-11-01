{
  flake.homeModules.git =
    {
      config,
      userconf,
      pkgs,
      lib,
      ...
    }:

    # REQUIRES PERSISTENT "$HOME/.config/gh/hosts.yml" "$HOME/.ssh/"

    let
      gconf = import ../../lib/git.nix;
      configs = gconf.configs;
      signingFile = "${config.xdg.configHome}/git/signing";
    in
    {
      programs = {
        git = {
          enable = true;

          signing = {
            format = "ssh";
            key = "${config.home.homeDirectory}/.ssh/signingkey";
            allowedSigners = lib.concatMapStringsSep "\n" (
              c: "${c.email} namespaces=\"git\" ${gconf.signingKey}"
            ) configs;
          };

          settings = {
            user = {
              name = userconf.displayname;
              email = userconf.email;
            };

            url = lib.listToAttrs (
              map (h: {
                name = h.url;
                value = {
                  insteadOf = h.alias;
                };
              }) gconf.hosts
            );

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

          includes = [
            { path = "~/.config/git/signing"; }
          ]
          ++ map (c: {
            condition = "hasconfig:remote.*.url:${c.remote}";
            contents.user = { inherit (c) name email; };
          }) (lib.filter (v: v.remote != null) configs);
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
      };

      home.activation.gitSigning = lib.hm.dag.entryAfter [ "writeBoundary" ] ''
        if [ -e "$HOME/.ssh/signingkey" ]; then
          printf '[commit]\n\tgpgsign = true\n[tag]\n\tgpgsign = true\n' > "${signingFile}"
        else
          rm -f "${signingFile}"
        fi
      '';
    };
}
