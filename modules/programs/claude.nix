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

        mcpServers.nixos = {
          type = "stdio";
          command = lib.getExe pkgs.mcp-nixos;
        };
      };

      home.packages = [ pkgs.claude-monitor ];
    };
}
