{
  flake.homeModules.opencode =
    {
      config,
      pkgs,
      lib,
      ...
    }:

    # REQURIES PRESERVATION OF "$HOME/.local/share/opencode/" "$HOME/.local/state/opencode/" "$HOME/.config/opencode"

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

      home.shellAliases."claude-auth" =
        "NIXPKGS_ALLOW_UNFREE=1 nix-shell -p claude-code --run 'claude && opencode'";
    };

}
