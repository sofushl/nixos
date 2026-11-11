# Copyright (C) 2026 Sofus Højberg Lind
# SPDX-License-Identifier: AGPL-3.0-or-later

{
  flake.homeModules.node =
    { pkgs, config, ... }:
    {
      programs = {
        npm = {
          enable = true;
          package = pkgs.nodejs_26;
          settings = {
            init-license = "AGPL-3.0-or-later";
            fund = false;
            update-notifier = false;
          };
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
