# Copyright (C) 2026 Sofus Højberg Lind
# SPDX-License-Identifier: AGPL-3.0-or-later

{
  flake.nixosModules.server =
    {
      config,
      userconf,
      lib,
      pkgs,
      ...
    }:
    {
      services.resolved = {
        enable = true;
        settings.Resolve = {
          LLMNR = "false";
          MulticastDNS = "false";
        };
      };

      services.logind.settings.Login = {
        HandleLidSwitch = "ignore";
        HandleLidSwitchExternalPower = "ignore";
        HandleLidSwitchDocked = "ignore";
      };

      users.users.${userconf.username}.linger = true;

      security.acme = {
        acceptTerms = true;
        defaults = {
          email = userconf.email;
          webroot = "/var/lib/acme/acme-challenge/";
        };

        certs = {
          "${userconf.topDom}" = {
            group = config.services.nginx.group;

            extraDomainNames = userconf.domains ++ map (site: site.domain) userconf.secretServices;
          };
        };
      };

      services.fail2ban.enable = true;

      services.nginx = {
        enable = true;
        recommendedProxySettings = true;
        recommendedTlsSettings = true;
        recommendedGzipSettings = true;

        virtualHosts."_" = {
          default = true;
          serverName = "_";
          addSSL = true;
          useACMEHost = userconf.topDom;
          locations."/".return = "444";
        };
      };

      systemd.network = {
        enable = true;

        links."10-eth" = {
          matchConfig.MACAddress = userconf.macaddress;
          linkConfig.Name = "eth";
        };

        networks."20-eth" = {
          matchConfig.Name = "eth";

          address = [
            "192.168.1.10/24"
          ];

          dns = [ "192.168.1.1" ];
          gateway = [ "192.168.1.1" ];

          networkConfig = {
            Gateway = "192.168.1.1";
            DNS = "192.168.1.1";
          };

        };
      };

      networking = {
        firewall = {
          enable = true;
          allowedTCPPorts = [
            22
            80
            443
          ];
        };
        useDHCP = lib.mkForce false;
      };
    };
}
