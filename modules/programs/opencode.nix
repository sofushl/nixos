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

        settings = {
          plugin = [ "opencode-claude-auth@latest" ];
        };
      };

      home.packages = with pkgs; [
        claude-code
      ];
    };
}
