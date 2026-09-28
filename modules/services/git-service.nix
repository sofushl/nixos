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
        locations = { };
      };
      withDefaults = service: serviceDefaults // service;
      gitServices = map withDefaults (userconf.gitServices ++ userconf.secretServices);

      running = lib.filter (service: service.start != null) gitServices;
      forwarded = lib.filter (service: service.domain != null) gitServices;

      pack = with pkgs; [
        git
        bash
      ];

      user = "git-service";
      hardening = service: {
        User = user;
        Group = user;
        ProtectSystem = "strict";
        ReadWritePaths = [ "/var/www/${service.name}" ];
        ProtectHome = true;
        PrivateTmp = true;
        NoNewPrivileges = true;
      };
    in
    {
      environment.systemPackages = pack;

      users.users.${user} = {
        isSystemUser = true;
        group = user;
        home = "/var/www";
      };
      users.groups.${user} = { };

      systemd.tmpfiles.rules = [
        "d /var/www 0755 root root -"
      ]
      ++ lib.concatMap (service: [
        "d /var/www/${service.name} 0755 ${user} ${user} -"
        "Z /var/www/${service.name} - ${user} ${user} -"
      ]) gitServices;

      security.polkit.enable = true;
      security.polkit.extraConfig = ''
        polkit.addRule(function(action, subject) {
          var units = ${builtins.toJSON (map (service: "app-${service.name}.service") running)};
          if (action.id == "org.freedesktop.systemd1.manage-units" &&
              subject.user == "${user}" &&
              action.lookup("verb") == "restart" &&
              units.indexOf(action.lookup("unit")) >= 0) {
            return polkit.Result.YES;
          }
        });
      '';

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
            after = [ "network-online.target" ];
            wants = [ "network-online.target" ];
            script = ''
              if [ ! -d /var/www/${service.name}/.git ]; then
                git clone ${service.repo} /var/www/${service.name}

                cd /var/www/${service.name}
                ${service.build}
                ${if (service.start == null) then "" else "systemctl restart app-${service.name}.service"}
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
                  ${if (service.start == null) then "" else "systemctl restart app-${service.name}.service"}
                  
                fi
              fi
            '';
            serviceConfig = hardening service // {
              Type = "oneshot";
            };
          };
        }) gitServices
        ++ map (service: {
          name = "app-${service.name}";
          value = {
            path = pack ++ service.pack;
            environment = {
              HOME = "/var/www/${service.name}";
            }
            // lib.optionalAttrs (service.port != null) {
              PORT = toString service.port;
            }
            // service.env;
            script = ''
              cd /var/www/${service.name}
              ${service.start}
            '';
            serviceConfig = hardening service // {
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
            root = "/var/www/${site.name}${site.subdir}";
            locations = site.locations;

          };
        }) forwarded
      );
    };
}
