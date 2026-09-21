{
  flake.homeModules.opencode =
    {
      pkgs,
      lib,
      stablepkgs,
      userconf,
      ...
    }:

    # REQURIES PRESERVATION OF "$HOME/.ollama" "$HOME/.local/share/opencode" "$HOME/.local/state/opencode" "$HOME/.config/opencode"

    let

      ponytail = pkgs.fetchFromGitHub {
        owner = "DietrichGebert";
        repo = "ponytail";
        rev = "e3ba2aa6f1e6f0bc4d69eb09c9f0d0a93af56156";
        hash = "sha256-PES5XrSYx0VBXWVHEDRykGy0SAmJfV/luzy8Gfg0aAQ=";
      };

      agentSkills = pkgs.fetchFromGitHub {
        owner = "addyosmani";
        repo = "agent-skills";
        rev = "dc27a9c2e13721158157632de61b4106c6c2a2a1";
        hash = "sha256-mliEs4QGO3W1vm5i4PfTNXCGtYVNUmEedWVmt5l7sxY=";
      };

    in
    {
      programs.opencode = {
        enable = true;

        web = {
          enable = true;
        };

        settings = {
          plugin = [
            "opencode-claude-auth@latest"
            ponytail
            agentSkills
          ];
        };

        enableMcpIntegration = true;
      };

      services.ollama = {
        enable = true;
        package = pkgs.ollama-cuda;
        acceleration = "cuda";
      };

      home.shellAliases."claude-auth" =
        "NIXPKGS_ALLOW_UNFREE=1 nix-shell -p claude-code --run 'claude && opencode'";
    };
}
