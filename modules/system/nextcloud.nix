{ self, inputs, ... }:

{
  flake.nixosModules.nextcloud =
    { userconf, ... }:

    {
      services.nextcloud = {
        enable = true;
        hostName = "cloud.${userconf.domain}";
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
