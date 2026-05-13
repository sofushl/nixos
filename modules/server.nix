{ self, inputs, ... }:

{
  flake.nixosModules.server =
    {
      pkgs,
      config,
      userconf,
      lib,
      ...
    }:

    let
      dom = userconf.domain;
      cloudDom = "cloud.${dom}";
    in
    {
      services = {
        nginx = {
          enable = true;
          recommendedProxySettings = true;
          recommendedTlsSettings = true;
          recommendedGzipSettings = true;

          virtualHosts = {

            ${dom} = {
              forceSSL = true;
              enableACME = true;

              root = "/var/www/homepage";

              extraConfig = ''
                index index.html;
              '';
            };

            ${cloudDom} = {
              forceSSL = true;
              enableACME = true;
            };
          };
        };

        resolved = {
          enable = true;
        };

        cron = {
          enable = true;
          systemCronJobs = [
            "0 * * * * wget -q --read-timeout=0.0 --waitretry=5 --tries=400 --background ${userconf.freednsupdate}"
          ];
        };

      };
      security.acme = {

        acceptTerms = true;
        defaults = {
          email = userconf.email;
          webroot = "/var/lib/acme/acme-challenge/";
        };
        certs = {
          "${dom}" = {
            group = config.services.nginx.group;

            extraDomainNames = [
              dom
              cloudDom
            ];
          };
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
            "192.168.1.111/24"
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
          allowedUDPPorts = [ ];
        };
        useDHCP = lib.mkForce false;
      };

      environment = {
        systemPackages = with pkgs; [
          wget
        ];
      };

    };
}
