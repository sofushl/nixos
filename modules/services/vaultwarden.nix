# Copyright (C) 2026 Sofus Højberg Lind
# SPDX-License-Identifier: AGPL-3.0-or-later

{
  flake.nixosModules.vaultwarden =
    {
      config,
      userconf,
      lib,
      pkgs,
      ...
    }:
    let
      domain = userconf.vaultDom;
      port = 8222;
    in
    {
      services.vaultwarden = {
        enable = true;
        dbBackend = "sqlite";
        backupDir = "/var/backup/vaultwarden";
        environmentFile = "/var/lib/secrets/vaultwarden.env";
        config = {
          DOMAIN = "https://${domain}";
          ROCKET_ADDRESS = "127.0.0.1";
          ROCKET_PORT = port;
          SIGNUPS_ALLOWED = false;
          INVITATIONS_ALLOWED = false;
          SHOW_PASSWORD_HINT = false;
          LOG_LEVEL = "warn";
          EXTENDED_LOGGING = true;
          EXPERIMENTAL_CLIENT_FEATURE_FLAGS = "ssh-key-vault-item,ssh-agent";
        };
      };

      services.nginx = {
        recommendedProxySettings = lib.mkDefault true;
        virtualHosts.${domain} = {
          enableACME = true;
          forceSSL = true;
          locations."/" = {
            proxyPass = "http://127.0.0.1:${toString port}";
            proxyWebsockets = true;
          };
          locations."/admin".return = "404";
        };
      };

      environment.etc."fail2ban/filter.d/vaultwarden.conf".text = ''
        [Definition]
        failregex = ^.*Username or password is incorrect\. Try again\. IP: <ADDR>\. Username:.*$
        ignoreregex =
        journalmatch = _SYSTEMD_UNIT=vaultwarden.service
      '';
      services.fail2ban.jails.vaultwarden.settings = {
        enabled = true;
        backend = "systemd";
        filter = "vaultwarden";
        maxretry = 5;
        findtime = "10m";
        bantime = "1h";
      };
    };
}
