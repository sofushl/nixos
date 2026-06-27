{
  flake.nixosModules.dnsUpdater =
    { userconf, pkgs, ... }:
    let
      pack = [ pkgs.wget ];
    in
    {
      systemd.services.dns-update = {
        path = pack;

        script = builtins.concatStringsSep "\n" (
          map (link: ''
            wget -q --read-timeout=0.0 --waitretry=5 --tries=100 --background ${link}
          '') userconf.dnsUpdateLinks
        );

        serviceConfig.Type = "oneshot";
      };

      systemd.timers.dns-update = {
        wantedBy = [ "timers.target" ];

        timerConfig = {
          OnStartupSec = "1m";
          OnUnitActiveSec = "30m";
        };
      };
    };
}
