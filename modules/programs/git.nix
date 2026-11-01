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
    # Signing needs an impure build: builtins.pathExists reads $HOME/.ssh/signingkey.

    let
      gconf = import ../../lib/git.nix;
      configs = gconf.configs;
      signingKey = "${config.home.homeDirectory}/.ssh/signingkey";
      hasSigningKey = builtins.pathExists signingKey;
    in
    {
      programs = {
        git = {
          enable = true;

          signing = {
            format = "ssh";
            key = signingKey;
            signByDefault = hasSigningKey;
            allowedSigners = lib.optionalString hasSigningKey (
              lib.concatMapStringsSep "\n" (c: "${c.email} namespaces=\"git\" ${gconf.signingKey}") configs
            );
          };

          settings = {
            commit.gpgsign = hasSigningKey;
            tag.gpgsign = hasSigningKey;

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

          includes = map (c: {
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
    };
}
