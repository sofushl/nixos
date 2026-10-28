{
  flake.homeModules.git =
    {
      userconf,
      pkgs,
      lib,
      ...
    }:

    # REQUIRES PERSISTENT "$HOME/.config/gh/hosts.yml" "$HOME/.ssh/"

    let
      gconf = import ../../lib/git.nix;
      configs = gconf.configs;
    in
    {
      home.file.".ssh/allowed_signers".text = lib.concatMapStringsSep "\n" (
        c: "${c.email} namespaces=\"git\" ${userconf.key}"
      ) configs;

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
              email = userconf.email;
              signingkey = userconf.key;
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

      services.ssh-agent.enable = true;

      home.shellAliases = {
        "pull" = "git pull";
        "push" = "git push";
      };
    };
}
