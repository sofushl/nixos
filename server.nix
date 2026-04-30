{
  config,
  userconf,
  lib,
  pkgs,
  ...
}:

{
  # Enable SSH server
  services = {
    openssh = {
      enable = true;
      allowSFTP = true;

      # Security baseline (do this from the start)

      settings = {
        PasswordAuthentication = false;
        PermitRootLogin = "no";
      };
    };

    nginx = {
      recommendedProxySettings = true;

      virtualHosts.${config.services.nextcloud.hostName} = {
        forceSSL = true;
        enableACME = true;
      };

      virtualHosts."office.${config.services.nextcloud.hostName}" = {
        forceSSL = true;
        enableACME = true;

        locations."/" = {
          proxyPass = "http://127.0.0.1:8000";
          proxyWebsockets = true;
        };
      };
    };

    nextcloud = {
      enable = true;
      hostName = userconf.host;
      https = true;

      config = {
        adminpassFile = "/etc/nextcloud-admin-pass";
        dbtype = "sqlite";
      };

      appstoreEnable = true;
      autoUpdateApps.enable = true;

      extraApps = {
        inherit (pkgs.nextcloud33Packages.apps) calendar onlyoffice;
      };

      settings = {
        trusted_domains = userconf.domains;
      };

    };

    onlyoffice = {
      enable = true;
      securityNonceFile = "/etc/onlyoffice-jwt";
    };

    resolved = {
      enable = true;
    };
  };

  security.acme = {
    acceptTerms = true;
    defaults.email = userconf.email;
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
        8000
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
  };
}
