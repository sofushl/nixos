{
  flake.homeModules.rclone = { userconf, config, ... }: {

    # REQUIRES PRESERVATION OF ".config/rclone/nextcloud.pass"

    home.shellAliases."nc-setup" =
      "mkdir -p ~/.config/rclone && (umask 077; rclone obscure \"$NCPASS\" > ~/.config/rclone/nextcloud.pass)";
    # run  NCPASS='yourAppPassword' nc-setup

    programs.rclone = {
      enable = true;
      remotes.nextcloud = {
        config = {
          type = "webdav";
          url = "https://${userconf.nextcloud}/remote.php/dav/files/${userconf.nextclouduser}/";
          vendor = "nextcloud";
          user = userconf.nextclouduser;
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
