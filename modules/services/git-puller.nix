{ self, inputs, ... }:

{
  flake.nixosModules.gitPuller =
    {
      userconf,
      pkgs,
      lib,
      ...
    }:

    {
      services.cron = {
        enable = true;
        systemCronJobs = map (dir: "*/1 * * * * sudo git -C ${dir} pull") userconf.gitPullers;
      };

      environment.systemPackages = [ pkgs.git ];
    };
}
