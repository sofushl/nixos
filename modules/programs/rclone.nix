{
  flake.homeModules.rclone =
    {
      userconf,
      config,
      lib,
      ...
    }:
    let
      cloudDir = "${config.home.homeDirectory}/Cloud";
      rcloneExe = lib.getExe config.programs.rclone.package;
    in
    {

      # REQUIRES PRESERVATION OF "$HOME/.config/rclone/nextcloud.pass" "$HOME/Cloud" "$HOME/.cache/rclone"

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
        };
      };

      systemd.user.services.rclone-bisync-nextcloud = {
        Unit.Description = "Bisync ~/Cloud with Nextcloud";
        Service = {
          Type = "oneshot";
          ExecStart = "${rcloneExe} bisync nextcloud: ${cloudDir} --resilient --recover --conflict-resolve newer";
        };
      };

      systemd.user.timers.rclone-bisync-nextcloud = {
        Unit.Description = "Run nextcloud bisync every minute";
        Timer = {
          OnBootSec = "1m";
          OnUnitActiveSec = "1m";
        };
        Install.WantedBy = [ "timers.target" ];
      };
    };
}
