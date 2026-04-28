{
  config,
  userconf,
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
        trusted_domains =  userconf.domains;
      };
    };

    nginx = {
      recommendedProxySettings = true;
      virtualHosts.${config.services.nextcloud.hostName} = {
        forceSSL = true;
        enableACME = true;
      }; 
    };
  };

  security.acme = {
    acceptTerms = true;
    certs = {
      ${config.services.nextcloud.hostName}.email = userconf.email;
    };
  };

  networking.firewall = {
    enable = true;
    allowedTCPPorts = [
      22
      80
      443
    ];
    allowedUDPPorts = [ ];
  };

  environment.etc."nextcloud-admin-pass".text = userconf.defaultpassword;
}
