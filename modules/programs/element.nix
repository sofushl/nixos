# Copyright (C) 2026 Sofus Højberg Lind
# SPDX-License-Identifier: AGPL-3.0-or-later

{
  flake.homeModules.element = { pkgs, lib, ... }: {

    # RECCOMENDED PRESERVATION OF "$HOME/.config/Element"

    programs.element-desktop = {
      enable = true;
      package = pkgs.element-desktop;
      settings = {
        default_server_config = {
          "m.homeserver" = {
            base_url = "https://matrix-client.matrix.org";
            server_name = "matrix.org";
          };
          "m.identity_server" = {
            base_url = "https://vector.im";
          };
        };
        disable_custom_urls = false;
        disable_guests = false;
        disable_login_language_selector = false;
        disable_3pid_login = false;
        force_verification = false;
        brand = "Element";
        integrations_ui_url = "https://scalar.vector.im/";
        integrations_rest_url = "https://scalar.vector.im/api";
        show_labs_settings = true;
        default_theme = "dark";
        room_directory.servers = [ "matrix.org" ];
        piwik = false;
        enable_presence_by_hs_url = {
          "https://matrix.org" = false;
          "https://matrix-client.matrix.org" = false;
        };
      };
    };

    systemd.user.services.element = {
      Unit = {
        Description = "Element";
        PartOf = [ "graphical-session.target" ];
        After = [ "graphical-session.target" ];
      };
      Service.ExecStart = "${lib.getExe pkgs.element-desktop} --hidden";
      Install.WantedBy = [ "graphical-session.target" ];
    };
  };
}
