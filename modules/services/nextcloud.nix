{
  flake.nixosModules.nextcloudServer =
    { userconf, pkgs, ... }:

    # REQUIRES PRESERVATION OF "/var/lib/nextcloud" AND "/var/lib/postgresql/"

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

          serverid = 1;

          log_type = "file";
        };

        phpOptions = {
          catch_workers_output = "yes";
          display_errors = "stderr";
          error_reporting = "E_ALL & ~E_DEPRECATED & ~E_STRICT";
          expose_php = "Off";
          "opcache.fast_shutdown" = "1";
          "opcache.interned_strings_buffer" = "16";
          "opcache.max_accelerated_files" = "10000";
          "opcache.memory_consumption" = "128";
          "opcache.revalidate_freq" = "1";
          output_buffering = "0";
          short_open_tag = "Off";
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
    };
}
