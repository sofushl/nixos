{ userconf, ... }: {
  programs = {
    git = {
      enable = true;

      settings = {

        user = {
          name = userconf.displayname;
          email = userconf.gitmail;
        };

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
}
