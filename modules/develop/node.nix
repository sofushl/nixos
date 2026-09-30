{
  flake.homeModules.node =
    { pkgs, config, ... }:
    {
      programs.npm = {
        enable = true;
        package = pkgs.nodejs_26;
        settings = {
          prefix = "${config.home.homeDirectory}/.npm";
          init-license = "MIT";
          color = true;
        };
      };

      home.sessionPath = [ "${config.home.homeDirectory}/.npm/bin" ];

      home.packages = with pkgs; [
        typescript
        typescript-language-server
        pnpm
        prettierd
        eslint_d
      ];
    };
}
