{
  flake.nixosModules.gitService =
    {
      userconf,
      pkgs,
      lib,
      ...
    }:
    let
      gitServices = [
        {
          name = "portfolio";
          root = "/dist";
          repo = "https://github.com/sofushl/portfolio.git";
          domain = userconf.topDom;
          build = ''
            npm i
            npm run build
          '';
          start = "";
        }
        {
          name = "AbaCordium";
          repo = "https://github.com/AbaCord/AbaCordium.git";
          root = "/";
          domain = null;
          build = ''
            npm i
          '';
          start = ''
            npm start
          '';
        }
      ]
      ++ userconf.secretServices;

      gitSites = lib.filter (service: service.domain != null) gitServices;

      pack = with pkgs; [
        git
        nodejs
        bash
      ];

    in
    {
      environment.systemPackages = pack;

      systemd.services = {
        git-service = {
          path = pack;

          script = ''
            mkdir -p /var/www

            ${lib.concatMapStringsSep "\n" (service: ''

              if [ ! -d /var/www/${service.name}/.git ]; then
                git clone ${service.repo} /var/www/${service.name}
                
                cd /var/www/${service.name}
                ${service.build}

                systemctl restart app-${service.name}.service

              else
                before=$(git -C /var/www/${service.name} rev-parse HEAD)

                echo "before: $before"

                git -C /var/www/${service.name} fetch origin
                git -C /var/www/${service.name} reset --hard origin/HEAD
                git -C /var/www/${service.name} checkout main
                
                cd /var/www/${service.name}
                
                after=$(git rev-parse HEAD)

                echo "after:  $after"

                if [ "$before" != "$after" ]; then
                  ${service.build}

                  systemctl restart app-${service.name}.service
                fi
              fi
            '') gitServices}
          '';

          serviceConfig.Type = "oneshot";
        };
      }
      // lib.listToAttrs (
        map (service: {
          name = "app-${service.name}";
          value = {
            path = pack;

            script = ''
              cd /var/www/${service.name}
              ${service.start}
            '';

            serviceConfig = {
              Type = "simple";
              Restart = "always";
              RestartSec = 5;
              User = "nginx";
            };

            wantedBy = [ "multi-user.target" ];
          };
        }) gitServices
      );

      systemd.timers.git-service = {
        wantedBy = [ "timers.target" ];

        timerConfig = {
          OnStartupSec = "1m";
          OnUnitActiveSec = "5m";
        };
      };

      services.nginx.enable = true;

      services.nginx.virtualHosts = lib.listToAttrs (
        map (site: {
          name = site.domain;
          value = {
            root = "/var/www/${site.name}${site.root}";
            forceSSL = true;
            enableACME = true;
            locations."/" = {
              tryFiles = "$uri $uri/ /index.html";
            };
          };
        }) gitSites
      );

      preservation.preserveAt.directories = [ "/var/www" ];
    };
}
