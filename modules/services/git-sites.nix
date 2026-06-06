{ self, inputs, ... }:

{
  flake.nixosModules.gitSites =
    {
      userconf,
      pkgs,
      lib,
      ...
    }:
    let
      sites = [
        {
          name = "homepage";
          repo = "https://github.com/sofuslind/homepage.git";
          domain = userconf.topDom;
        }

        {
          name = "secretpage";
          repo = userconf.secretGit;
          domain = userconf.secretDom;
        }
      ];

    in
    {
      environment.systemPackages = [ pkgs.git ];

      systemd.services.git-site-update = {
        path = [ pkgs.git ];

        script = ''
          mkdir -p /var/www

          ${lib.concatMapStringsSep "\n" (site: ''
            if [ ! -d /var/www/${site.name}/.git ]; then
              git clone ${site.repo} /var/www/${site.name}
            else
              git -C /var/www/${site.name} fetch origin
              git -C /var/www/${site.name} reset --hard origin/HEAD
            fi
          '') sites}
        '';

        serviceConfig.Type = "oneshot";
      };

      systemd.timers.git-site-update = {
        wantedBy = [ "timers.target" ];

        timerConfig = {
          OnBootSec = "1m";
          OnUnitActiveSec = "5m";
        };
      };

      services.nginx.enable = true;

      services.nginx.virtualHosts = lib.listToAttrs (
        map (site: {
          name = site.domain;
          value = {
            root = "/var/www/${site.name}";
            forceSSL = true;
            enableACME = true;
          };
        }) sites
      );

      preservation.preserveAt.directories = [ "/var/www" ];
    };
}
