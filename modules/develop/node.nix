# Copyright (C) 2026 Sofus Højberg Lind
# SPDX-License-Identifier: AGPL-3.0-or-later

{
  flake.nixosModules.node =
    {
      pkgs,
      config,
      userconf,
      ...
    }:

    # RECOMMENDED PRESERVATION OF "$HOME/.npmrc" "$HOME/.npm/"

    {
      programs.npm = {
        enable = true;
        package = pkgs.nodejs_26;
        npmrc = ''
          prefix = ''${HOME}/.npm
          init-license=LGPL-3.0-or-later
          init-author-name=${userconf.displayname}
          init-author-email=${userconf.email}
          color=true
          update-notifier=false
          fund=false
        '';
      };
    };

  flake.homeModules.bun = { pkgs, ... }: {
    programs.bun = {
      enable = true;
      package = pkgs.bun;
      enableGitIntegration = true;
      settings.telemetry = false;
    };
  };
}
