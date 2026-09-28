{
  flake.nixosModules.dnsUpdater =
    {
      userconf,
      lib,
      pkgs,
      ...
    }:
    {
      systemd.services.dns-update = {
        after = [ "network-online.target" ];
        wants = [ "network-online.target" ];

        script = lib.concatMapStringsSep "\n" (
          link:
          "${lib.getExe pkgs.wget} -q -O /dev/null --read-timeout=0.0 --waitretry=20 --tries=50 ${lib.escapeShellArg link} || true"
        ) userconf.dnsUpdateLinks;

        serviceConfig = {
          Type = "oneshot";
          DynamicUser = true;
          ProtectSystem = "strict";
          ProtectHome = true;
          PrivateTmp = true;
          NoNewPrivileges = true;
        };
      };

      systemd.timers.dns-update = {
        wantedBy = [ "timers.target" ];
        timerConfig = {
          OnBootSec = "1m";
          OnUnitActiveSec = "15m";
        };
      };
    };
}
