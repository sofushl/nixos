# Copyright (C) 2026 Sofus Højberg Lind
# SPDX-License-Identifier: AGPL-3.0-or-later

{
  flake.homeModules.mako =
    {
      config,
      lib,
      userconf,
      ...
    }:
    let
      c = userconf.theme;
    in
    {

      services.mako = {
        enable = true;
        settings = {
          "actionable=true" = {
            anchor = "top-left";
            default-timeout = 3000;
            ignore-timeout = "1";
          };
          actions = true;
          anchor = "top-right";
          background-color = c.bg.primary;
          text-color = c.text.primary;
          border-color = c.primary;
          progress-color = "over ${c.primary}";
          border-size = 2;
          border-radius = 0;
          default-timeout = 3000;
          font = "monospace 10";
          height = 100;
          icons = true;
          ignore-timeout = "1";
          layer = "top";
          margin = 10;
          padding = 10;
          markup = true;
          width = 300;
        };
      };

      systemd.user.services.mako = {
        Unit = {
          Description = "mako notification daemon";
          PartOf = [ "graphical-session.target" ];
          After = [ "graphical-session.target" ];
        };
        Service = {
          ExecStart = lib.getExe config.services.mako.package;
          Restart = "on-failure";
        };
        Install.WantedBy = [ "graphical-session.target" ];
      };
    };
}
