{ selv, inputs, ... }:

{
  flake.homeModules.git = {
    programs.git = {
      enable = true;

      settings = {
        init.defaultBranch = "main";
        pull.rebase = true;
        core.editor = "nvim";
      };
    };
  };
}
