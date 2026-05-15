{ self, inputs, ... }:

{
  flake.nixosModules.freeDNS =
    { userconf, pkgs, ... }:

    {
      services.cron = {
        enable = true;
        systemCronJobs = [
          "0 * * * * wget -q --read-timeout=0.0 --waitretry=5 --tries=400 --background ${userconf.freednsUpdate}"
        ];
      };

      environment.systemPackages = [ pkgs.wget ];
    };
}
