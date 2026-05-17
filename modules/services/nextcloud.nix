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

        appstoreEnable = true;
        autoUpdateApps.enable = true;

      };
      environment.etc."nextcloud-admin-pass".text = userconf.password;

    };
}
