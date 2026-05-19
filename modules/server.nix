{
  self,
  inputs,
  pkgs,
  config,
  userconf,
  lib,
  ...
}:

{
  flake.nixosModules.server = {

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

          extraDomainNames = userconf.domains;
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
        allowedUDPPorts = [
        ];
      };
      useDHCP = lib.mkForce false;
    };

  };
}
