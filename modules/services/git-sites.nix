{ self, inputs, ... }:

{
  flake.nixosModules.gitSites =
    {
      userconf,
      pkgs,
      lib,
      config,
      ...
    }:
    {
      my.gitSites = [
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

      options.my.gitSites = lib.mkOption {
        type = lib.types.listOf (
          lib.types.submodule {
            options = {
              name = lib.mkOption {
                type = lib.types.str;
              };

              repo = lib.mkOption {
                type = lib.types.str;
              };

              domain = lib.mkOption {
                type = lib.types.str;
              };
            };
          }
        );

        default = [ ];
      };

      config =
        let
          sites = config.my.gitSites;
        in
        {
          environment.systemPackages = [ pkgs.git ];

          systemd.services.git-site-update = {
            script = ''
              mkdir -p /var/lib/git-sites

              ${lib.concatMapStringsSep "\n" (site: ''
                if [ ! -d /var/lib/git-sites/${site.name}/.git ]; then
                  git clone ${site.repo} /var/lib/git-sites/${site.name}
                else
                  git -C /var/lib/git-sites/${site.name} fetch origin
                  git -C /var/lib/git-sites/${site.name} reset --hard origin/HEAD
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
                root = "/var/lib/git-sites/${site.name}";
              };
            }) sites
          );
        };
    };
}
