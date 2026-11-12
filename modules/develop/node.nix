# Copyright (C) 2026 Sofus Højberg Lind
# SPDX-License-Identifier: AGPL-3.0-or-later

{
  flake.homeModules.node =
    { pkgs, config, ... }:

    # RECOMMENDED PRESERVATION OF "$HOME/.npmrc"

    {
      programs = {
        npm = {
          enable = true;
          package = pkgs.nodejs_26;
        };

        bun = {
          enable = true;
          package = pkgs.bun;
          enableGitIntegration = true;
          settings = {
            telemetry = false;
          };
        };
      };

      home.sessionPath = [ "${config.home.homeDirectory}/.npm/bin" ];

      home.packages = with pkgs; [
        typescript
        prettierd
        eslint_d
      ];
    };
}
