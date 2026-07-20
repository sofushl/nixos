{
  flake.nixosModules.nextcloudServer =
    { userconf, pkgs, ... }:

    {
      services.nextcloud = {
        enable = true;
        hostName = userconf.cloudDom;
        https = true;
        database.createLocally = true;
        package = pkgs.nextcloud34;

        config = {
          adminuser = null;

          dbtype = "pgsql";
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

      preservation.preserveAt.directories = [ "/var/lib/nextcloud" ];

    };

}
