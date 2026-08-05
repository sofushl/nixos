{
  flake.homeModules.rclone = { userconf, config, ... }: {

    programs.rclone = {
      enable = true;
      remotes.nextcloud = {
        config = {
          type = "webdav";
          url = "https://cloud.sofus.privatedns.org/remote.php/dav/files/${userconf.username}/";
          vendor = "nextcloud";
          user = userconf.username;
        };
        secrets.pass = "${config.xdg.configHome}/rclone/nextcloud.pass";

        mounts."" = {
          enable = true;
          autoMount = true;
          mountPoint = "${config.home.homeDirectory}/Cloud";
          options = {
            vfs-cache-max-age = "24h";
            vfs-cache-max-size = "10G";
            dir-cache-time = "30s";
            poll-interval = "0";
          };
        };
      };
    };
  };
}
