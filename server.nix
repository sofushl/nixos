{
  config,
  userconf,
  lib,
  pkgs,
  ...
}:

let
  dom = userconf.domain;

  officeDom = "docs.${userconf.domain}";

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

          locations."/" = {
            proxyPass = "http://127.0.0.1:11000";

            proxyWebsockets = true;

            extraConfig = ''
              client_max_body_size 10G;

              proxy_read_timeout 36000s;
              proxy_send_timeout 36000s;
              proxy_connect_timeout 36000s;

              proxy_buffering off;
            '';
          };
        };

        #${officeDom} = {
        #  forceSSL = true;
        #  enableACME = true;
        #};
      };
    };

    #nextcloud = {
    #  enable = true;
    #  hostName = cloudDom;
    #  https = true;

    #  config = {
    #    adminpassFile = "/etc/nextcloud-admin-pass";
    #    dbtype = "sqlite";
    #  };

    #  appstoreEnable = true;
    #  autoUpdateApps.enable = true;

    #  settings = {
    #    trusted_domains = userconf.domains;
    #  };

    #};

    #onlyoffice = {
    #  enable = true;
    #  securityNonceFile = "/etc/onlyoffice-jwt";
    #};

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

  virtualisation = {
    docker.enable = true;

    oci-containers = {
      backend = "docker";
      containers.nextcloud-aio-mastercontainer = {
        image = "nextcloud/all-in-one:latest";

        autoStart = true;

        ports = [
          "127.0.0.1:8080:8080"
        ];

        volumes = [
          "nextcloud_aio_mastercontainer:/mnt/docker-aio-config"
          "/var/run/docker.sock:/var/run/docker.sock:ro"

          # actual user data
          "/srv/nextcloud:/mnt/ncdata"
        ];

        environment = {
          APACHE_PORT = "11000";
          APACHE_IP_BINDING = "127.0.0.1";

          NEXTCLOUD_DATADIR = "/mnt/ncdata";

          SKIP_DOMAIN_VALIDATION = "false";
        };

        extraOptions = [
          "--init"
          "--restart=always"
        ];
      };
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
