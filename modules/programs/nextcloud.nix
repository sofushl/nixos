{ self, inputs, ... }:

{
  flake.nixosModules.nextcloudClient =
    { userconf, pkgs, ... }:

    {
      environment.systemPackages = [ pkgs.nextcloud-client ];

      home-manager.users.${userconf.username}.services.nextcloud-client = {
        enable = true;
        startInBackground = true;
      };
    };
}
