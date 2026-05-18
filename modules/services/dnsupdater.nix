{ self, inputs, ... }:

{
  flake.nixosModules.dnsUpdater =
    { userconf, pkgs, ... }:

    {
      services.cron = {
        enable = true;
        systemCronJobs = map (
          link: "0 * * * * wget -q --read-timeout=0.0 --waitretry=5 --tries=100 --background ${link}"
        ) userconf.dnsUpdateLinks;
      };

      environment.systemPackages = [ pkgs.wget ];
    };
}
