{ self, inputs, ... }:

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
      services.resolved.enable = true;

      security.acme = {

        acceptTerms = true;
        defaults = {
          email = userconf.email;
          webroot = "/var/lib/acme/acme-challenge/";
        };

        certs = {
          "${userconf.topDom}" = {
            group = config.services.nginx.group;

            extraDomainNames = userconf.domains ++ map (site: site.domain) userconf.secretPages;
          };
        };
      };

      services.nginx = {
        enable = true;
        recommendedProxySettings = true;
        recommendedTlsSettings = true;
        recommendedGzipSettings = true;

        virtualHosts.${userconf.secondaryDom} = {
          forceSSL = true;
          enableACME = true;
          globalRedirect = userconf.topDom;
        };
      };

      systemd.network = {
        enable = true;

        links."10-eth-usb" = {
          matchConfig.MACAddress = userconf.macaddress;
          linkConfig.Name = "eth-usb";
        };

        networks."20-eth-usb" = {
          matchConfig.Name = "eth-usb";

          address = [
            "192.168.1.10"
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
          allowedUDPPorts = [
          ];
        };
        useDHCP = lib.mkForce false;
      };

    };
}
