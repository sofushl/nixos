{
  flake.homeModules.rclone =
    {
      userconf,
      config,
      lib,
      pkgs,
      ...
    }:
    let
      cloudDir = "${config.home.homeDirectory}/Cloud";
      rcloneExe = lib.getExe config.programs.rclone.package;
      bisyncCmd = "${rcloneExe} bisync nextcloud: ${cloudDir} --resilient --recover --conflict-resolve newer";
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

      systemd.user.services."unit-status-failure-notify@" = {
        Unit.Description = "Notify about failure of %i";
        Service = {
          Type = "oneshot";
          ExecStart = "${pkgs.writeShellScript "notify-failure" ''
            stamp="$2/rclone-bisync/last-success"
            if [ -r "$stamp" ]; then
              last=$(cat "$stamp")
            else
              last="never"
            fi
            ${lib.getExe pkgs.libnotify} --urgency=critical -i error \
              "$1 failed" "Last bisync success: $last"
          ''} %i %S";
        };
      };

      systemd.user.services.rclone-bisync-nextcloud = {
        Unit = {
          Description = "Bisync ~/Cloud with Nextcloud";
          OnFailure = [ "unit-status-failure-notify@%n.service" ];
        };
        Service = {
          Type = "oneshot";
          StateDirectory = "rclone-bisync"; # creates ~/.local/state/rclone-bisync
          ExecStart = bisyncCmd;
          ExecStartPost = "${pkgs.runtimeShell} -c '${pkgs.coreutils}/bin/date > %S/rclone-bisync/last-success'";
        };
      };

      systemd.user.timers.rclone-bisync-nextcloud = {
        Unit.Description = "Run nextcloud bisync on boot and every 5 minutes";
        Timer = {
          OnBootSec = "1m";
          OnUnitActiveSec = "2m";
        };
        Install.WantedBy = [ "timers.target" ];
      };
    };
}
