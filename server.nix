{
  config,
  userconf,
  lib,
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

    nextcloud = {
      enable = true;
      hostName = userconf.hostname;
      https = true;

      config = {
        adminpassFile = "/etc/nextcloud-admin-pass";
        dbtype = "sqlite";
      };

      settings = {
        trusted_domains = userconf.domains;
      };
    };

    nginx = {
      recommendedProxySettings = true;
      virtualHosts.${config.services.nextcloud.hostName} = {
        forceSSL = true;
        enableACME = true;
      };
    };

    resolved = {
      enable = true;
    };
  };

  security.acme = {
    acceptTerms = true;
    certs = {
      ${config.services.nextcloud.hostName}.email = userconf.email;
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
    networkmanager.enable = lib.mkForce true;
  };

  environment.etc."nextcloud-admin-pass".text = userconf.defaultpassword;
}
