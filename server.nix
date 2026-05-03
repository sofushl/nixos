{
  config,
  userconf,
  lib,
  pkgs,
  ...
}:

let
  dom = userconf.domain;

  officeDom = "office.${userconf.domain}";

  cloudDom = "cloud.${userconf.domain}";

in
{
  services = {
    openssh = {
      enable = true;
      allowSFTP = true;

      settings = {
        PasswordAuthentication = false;
        PermitRootLogin = "no";
      };
    };

    nginx = {

      enable = true;
      recommendedProxySettings = true;
      recommendedTlsSettings = true;

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

        ${officeDom} = {
          forceSSL = true;
          enableACME = true;
        };
      };
    };

    nextcloud = {
      enable = true;
      hostName = cloudDom;
      https = true;

      config = {
        adminpassFile = "/etc/nextcloud-admin-pass";
        dbtype = "sqlite";
      };

      appstoreEnable = true;
      autoUpdateApps.enable = true;

      settings = {
        trusted_domains = userconf.domains;
      };

    };

    onlyoffice = {
      enable = true;
      securityNonceFile = "/etc/onlyoffice-jwt";
      hostname = officeDom;
      port = 8000;
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
          officeDom
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
    networkmanager.enable = lib.mkForce false;
    useDHCP = lib.mkForce false;
  };

  environment = {
    etc = {
      "nextcloud-admin-pass".text = userconf.defaultpassword;
      "onlyoffice-jwt".text = ''
        set $secure_link_secret "${userconf.onlyofficejwt}";
      '';
    };

    systemPackages = with pkgs; [
      wget
    ];
  };

}
