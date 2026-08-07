{
  flake.homeModules.opencode =
    {
      config,
      pkgs,
      lib,
      ...
    }:
    {
      programs.opencode = {
        enable = true;

        web = {
          enable = true;
        };
      };
    };
}
