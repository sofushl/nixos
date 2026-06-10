{ self, inputs, ... }:

{
  flake.nixosModules.nextcloudServer =
    { userconf, ... }:

    {
      services.nextcloud = {
        enable = true;
        hostName = userconf.cloudDom;
        https = true;
        database.createLocally = true;

        config = {
          adminuser = userconf.username;
          adminpassFile = "/etc/nextcloud-admin-pass";

          dbtype = "sqlite";
          #dbtype = "pgsql";
          dbname = "nextcloud";
          dbuser = "nextcloud";
        };

        settings = {
          maintenance_window_start = 2;
          default_phone_region = "NO";
          server_id = "main";
          integrity.check.disabled = false;
        };

        appstoreEnable = true;
        autoUpdateApps.enable = true;

        caching.redis = true;

      };

      services.nginx.virtualHosts = {
        ${userconf.cloudDom} = {
          forceSSL = true;
          enableACME = true;
        };
      };

      environment.etc."nextcloud-admin-pass".text = userconf.password;

      services.postgresql = {
        enable = true;
        ensureDatabases = [ "nextcloud" ];
        ensureUsers = [
          {
            name = "nextcloud";
            ensureDBOwnership = true;
          }
        ];
      };

      systemd.services."nextcloud-setup" = {
        requires = [ "postgresql.service" ];
        after = [ "postgresql.service" ];
      };

      preservation.preserveAt.directories = [ "/var/lib/nextcloud" ];

    };

}
