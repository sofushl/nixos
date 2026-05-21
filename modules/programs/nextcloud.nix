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

      systemd.user.services.nextcloud-documents-symlink = {
        script = ''
          ln -sfn \
          /home/${userconf.username}/.nextcloud/Documents \
          /home/${userconf.username}/Documents
        '';

        serviceConfig.Type = "oneshot";

        wantedBy = [ "default.target" ];
      };

      preservation.preserveAt."/persistent".users.${userconf.username}.directories = [
        ".nextcloud"
        ".config/Nextcloud"
      ];
    };

}
