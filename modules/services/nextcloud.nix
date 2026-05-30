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
        };

        settings = {
          maintenance_window_start = 2;
          default_phone_region = "NO";
          server_id = "main";
          integrity.check.disabled = false;
        };

        appstoreEnable = true;
        autoUpdateApps.enable = true;

      };
      environment.etc."nextcloud-admin-pass".text = userconf.password;

    };
}
