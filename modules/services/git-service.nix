{
  flake.nixosModules.gitService =
    {
      userconf,
      pkgs,
      lib,
      ...
    }:

    # REQURIES PRESERVATION OF "/var/www"

    let
      serviceDefaults = {
        name = throw "gitServices: name is required";
        subdir = "/";
        repo = throw "gitServices: repo is required";
        domain = null;
        port = null;
        build = "";
        start = null;
        env = { };
        pack = [ pkgs.nodejs ];
      };
      withDefaults = service: serviceDefaults // service;
      gitServices = map withDefaults (userconf.gitServices ++ userconf.secretServices);

      forwarded = lib.filter (service: service.domain != null) gitServices;
      running = lib.filter (service: service.start != null) gitServices;

      pack = with pkgs; [
        git
        bash
      ];
    in
    {
      environment.systemPackages = pack;

      systemd.services = lib.listToAttrs (
        map (service: {
          name = "git-update-${service.name}";
          value = {
            path = pack ++ service.pack;
            environment = {
              HOME = "/var/www/${service.name}";
              GIT_CONFIG_COUNT = "1";
              GIT_CONFIG_KEY_0 = "safe.directory";
              GIT_CONFIG_VALUE_0 = "/var/www/${service.name}";
            }
            // service.env;
            script = ''
              mkdir -p /var/www
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
            '';
            serviceConfig.Type = "oneshot";
          };
        }) gitServices
        ++ map (service: {
          name = "app-${service.name}";
          value = {
            path = pack ++ service.pack;
            environment =
              lib.optionalAttrs (service.port != null) {
                PORT = toString service.port;
              }
              // service.env;
            script = ''
              cd /var/www/${service.name}
              ${service.start}
            '';
            serviceConfig = {
              Type = "simple";
              Restart = "always";
              RestartSec = 5;
            };
            wantedBy = [ "multi-user.target" ];
          };
        }) running
      );

      systemd.timers = lib.listToAttrs (
        map (service: {
          name = "git-update-${service.name}";
          value = {
            wantedBy = [ "timers.target" ];
            timerConfig = {
              OnStartupSec = "1m";
              OnUnitActiveSec = "5m";
              RandomizedDelaySec = "30s";
            };
          };
        }) gitServices
      );

      services.nginx.enable = true;

      services.nginx.virtualHosts = lib.listToAttrs (
        map (site: {
          name = site.domain;
          value = {
            forceSSL = true;
            enableACME = true;
          }
          // (
            if (site.port or null) != null then
              {
                locations."/" = {
                  proxyPass = "http://127.0.0.1:${toString site.port}";
                };
              }
            else
              {
                root = "/var/www/${site.name}${site.subdir}";
                locations."/".tryFiles = "$uri $uri/ /index.html";
              }
          );
        }) forwarded
      );
    };
}
