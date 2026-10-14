{
  flake.nixosModules.satisfactoryServer =
    {
      config,
      pkgs,
      lib,
      userconf,
      ...
    }:
    let
      installDir = "/var/lib/satisfactory/SatisfactoryDedicatedServer";
      configDir = "${installDir}/FactoryGame/Saved/Config/LinuxServer";
      beta = false;
      address = "0.0.0.0";
      maxPlayers = 5;
      autoPause = true;
      autoSaveOnDisconnect = true;
    in
    {
      users.users.satisfactory = {
        home = "/var/lib/satisfactory";
        createHome = true;
        isSystemUser = true;
        group = "satisfactory";
        uid = 9134;
      };
      users.groups.satisfactory = {
        gid = 9134;
      };

      networking.firewall = {
        allowedUDPPorts = [ 7777 ];
        allowedTCPPorts = [
          7777
          8888
        ];
      };

      systemd.services.satisfactory = {
        description = "Satisfactory Dedicated Server";
        restartIfChanged = false;
        #wantedBy = [ "multi-user.target" ];
        after = [ "network-online.target" ];
        wants = [ "network-online.target" ];

        preStart = ''
          ${pkgs.steamcmd}/bin/steamcmd \
            +force_install_dir ${installDir} \
            +login anonymous \
            +app_update 1690800 ${if beta then "-beta experimental" else ""} \
            validate \
            +quit < /dev/null || [ -x ${installDir}/Engine/Binaries/Linux/FactoryServer-Linux-Shipping ]

          # Steam SDK symlink expected by the server 
          mkdir -p /var/lib/satisfactory/.steam/sdk64
          ln -sfn ${installDir}/linux64/steamclient.so \
          /var/lib/satisfactory/.steam/sdk64/steamclient.so

          # Write server config
          mkdir -p ${configDir}

          ${pkgs.crudini}/bin/crudini --set \
            ${configDir}/Game.ini \
            '/Script/Engine.GameSession' \
            MaxPlayers \
            ${toString maxPlayers}

          ${pkgs.crudini}/bin/crudini --set \
            ${configDir}/ServerSettings.ini \
            '/Script/FactoryGame.FGServerSubsystem' \
            mAutoPause \
            ${if autoPause then "True" else "False"}

          ${pkgs.crudini}/bin/crudini --set \
            ${configDir}/ServerSettings.ini \
            '/Script/FactoryGame.FGServerSubsystem' \
            mAutoSaveOnDisconnect \
            ${if autoSaveOnDisconnect then "True" else "False"}

          for i in $(seq 90); do
            ${pkgs.iproute2}/bin/ss -Htan '( sport = :7777 )' | ${pkgs.gnugrep}/bin/grep -q . || break
            sleep 1
          done
        '';

        script = ''
          ${pkgs.steam-run}/bin/steam-run \
            ${installDir}/Engine/Binaries/Linux/FactoryServer-Linux-Shipping \
            FactoryGame \
            -multihome=${address} \
            -Port=7777 \
            -ReliablePort=8888
        '';

        serviceConfig = {
          User = "satisfactory";
          Group = "satisfactory";
          StateDirectory = "satisfactory";
          StateDirectoryMode = "0750";
          WorkingDirectory = "/var/lib/satisfactory";
          Restart = "on-failure";
          RestartSec = "10s";
          TimeoutStartSec = "30min";
          Nice = "-5";
        }
        // userconf.minecraft.prioServiceConfig;

        environment = {
          LD_LIBRARY_PATH = lib.concatStringsSep ":" [
            "${installDir}/linux64"
            "${installDir}/Engine/Binaries/Linux"
            "${installDir}/Engine/Binaries/ThirdParty/PhysX3/Linux/x86_64-unknown-linux-gnu"
          ];
        };
      };
      services.webhook = {
        verbose = true;
        enable = true;
        ip = "127.0.0.1";
        port = 9000;
        enableTemplates = true;
        hooksTemplated = builtins.listToAttrs (
          map
            (action: {
              name = "satisfactory-${action}";
              value = ''
                {
                  "id": "satisfactory-${action}",
                  "execute-command": "${pkgs.systemd}/bin/systemctl",
                  "include-command-output-in-response": true,
                  "include-command-output-in-response-on-error": true,
                  "pass-arguments-to-command": [
                    { "source": "string", "name": "${action}" },
                    { "source": "string", "name": "satisfactory.service" }
                  ],
                  "http-methods": ["POST"],
                  "trigger-rule": {
                    "match": {
                      "type": "value",
                      "value": "{{ getenv "SATISFACTORY_TOKEN" | js }}",
                      "parameter": { "source": "header", "name": "X-Token" }
                    }
                  }
                }
              '';
            })
            [
              "start"
              "stop"
              "restart"
              "is-active"
            ]
        );
      };

      # file contains: SATISFACTORY_TOKEN=<long random string>
      systemd.services.webhook.serviceConfig.EnvironmentFile = "/var/lib/secrets/webhook.env";

      security.polkit.extraConfig = ''
        polkit.addRule(function(action, subject) {
          if (action.id == "org.freedesktop.systemd1.manage-units" &&
              action.lookup("unit") == "satisfactory.service" &&
              subject.user == "${config.services.webhook.user}") {
            return polkit.Result.YES;
          }
        });
      '';

      services.nginx.virtualHosts.${userconf.sfDom} = {
        enableACME = true;
        forceSSL = true;
        locations."/hooks/".proxyPass = "http://127.0.0.1:9000";
      };
    };
}
