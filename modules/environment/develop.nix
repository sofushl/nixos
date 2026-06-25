{ self, inputs, ... }:

{
  flake.nixosModules.develop =
    { userconf, pkgs, ... }:
    {
      home-manager.users.${userconf.username}.programs = {
        npm = {
          enable = true;
          package = pkgs.nodejs_26;
          settings = {
            color = true;
            include = [
              "dev"
              "prod"
            ];
            init-license = "MIT";
            prefix = "\${HOME}/.npm";
          };
        };

        uv.enable = true;
      };

      programs = {
        npm = {
          enable = true;
          package = pkgs.nodejs_26;
          npmrc = ''
            prefix = ''${HOME}/.npm
            init-license=MIT
            color=true
          '';
        };
      };

      environment.systemPackages = with pkgs; [
        # Languages
        lua
        gcc
        nixd
        typescript

        # Formatter
        nixfmt
        kdlfmt
        yamlfmt
        rustfmt
        prettierd
        prettier
        eslint
        black
        isort
        google-java-format
        vscode-langservers-extracted
      ];
    };
}
