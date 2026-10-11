{
  flake.nixosModules.satisfactoryServer =
    {
      userconf,
      pkgs,
      lib,
      ...
    }:

    # REQUIRES PRESERVATION OF "/var/lib/satisfactory", "/var/lib/containers" AND "/etc/satisfactory-api.env"

    let
      unit = "podman-satisfactory.service";
      user = "satisfactory-api";
      systemctl = lib.getExe' pkgs.systemd "systemctl";
    in
    {
      virtualisation.oci-containers.containers = {
        satisfactory = {
          image = "ghcr.io/robtme/satisfactory-server:latest";

          autoStart = false;

          ports = [
            "7777:7777/tcp"
            "7777:7777/udp"
            "8888:8888/tcp"
          ];

          volumes = [ "/var/lib/satisfactory:/config" ];

          environment = {
            MAXPLAYERS = "3";
            PUID = "1000";
            PGID = "1000";
            STEAMBETA = "false";
            SKIPUPDATE = "true";
          };

          extraOptions = [
            "--memory=12g"
            "--memory-reservation=4g"
          ];
        };
      };

      networking.firewall.allowedTCPPorts = [
        7777
        8888
      ];
      networking.firewall.allowedUDPPorts = [ 7777 ];

      users.users.${user} = {
        isSystemUser = true;
        group = user;
      };
      users.groups.${user} = { };

      services.webhook = {
        enable = true;
        ip = "127.0.0.1";
        port = 9010;
        inherit user;
        group = user;

        # One hook per systemctl verb, served at /hooks/<verb>.
        # hooksTemplated (literal JSON strings) is used instead of `hooks` because the token
        # check uses Go template syntax, which would get mangled by Nix's JSON escaping.
        hooksTemplated = lib.genAttrs [ "start" "stop" "is-active" ] (verb: ''
          {
            "id": "${verb}",
            "http-methods": ["POST"],
            "execute-command": "${systemctl}",
            "pass-arguments-to-command": [
              { "source": "string", "name": "${verb}" },
              { "source": "string", "name": "${unit}" }
            ],
            "include-command-output-in-response": true,
            "include-command-output-in-response-on-error": true,
            "trigger-rule": {
              "match": {
                "type": "value",
                "value": "Bearer {{ getenv "SATISFACTORY_API_TOKEN" }}",
                "parameter": { "source": "header", "name": "Authorization" }
              }
            }
          }
        '');
      };

      # Provides SATISFACTORY_API_TOKEN to webhook without putting the token in the Nix store.
      # Changing the token requires `systemctl restart webhook`.
      systemd.services.webhook.serviceConfig.EnvironmentFile = "/etc/satisfactory-api.env";

      # webhook runs as an unprivileged user; this grants it start/stop on the game unit only.
      # `is-active` is read-only and needs no permission.
      security.polkit.enable = true;
      security.polkit.extraConfig = ''
        polkit.addRule(function(action, subject) {
          var verbs = ["start", "stop"];
          if (action.id == "org.freedesktop.systemd1.manage-units" &&
              subject.user == "${user}" &&
              action.lookup("unit") == "${unit}" &&
              verbs.indexOf(action.lookup("verb")) >= 0) {
            return polkit.Result.YES;
          }
        });
      '';

      # Public HTTPS entrypoint; only /hooks/ is proxied.
      services.nginx.virtualHosts.${userconf.sfDom} = {
        forceSSL = true;
        enableACME = true;
        locations."/hooks/".proxyPass = "http://127.0.0.1:9010";
      };
    };
}
