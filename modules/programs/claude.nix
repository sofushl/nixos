{
  flake.homeModules.claude =
    {
      pkgs,
      lib,
      ...
    }:

    # REQUIRES PRESERVATION OF "$HOME/.claude.json" "$HOME/.claude/"

    {
      programs.claude-code = {
        enable = true;
        package = pkgs.claude-code;
      };

      home.packages = [ pkgs.claude-monitor ];
    };
}
