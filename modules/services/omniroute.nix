{
  flake.nixosModules.omniroute =
    {
      config,
      userconf,
      pkgs,
      ...
    }:
    {
      virtualisation.podman.enable = true;
      virtualisation.oci-containers.backend = "podman";

      virtualisation.oci-containers.containers.omniroute = {
        image = "docker.io/diegosouzapw/omniroute:latest";
        ports = [ "127.0.0.1:20128:20128" ];
        volumes = [ "/var/lib/omniroute:/data" ];
        environment = {
          DATA_DIR = "/data";
          PORT = "20128";
          REQUIRE_API_KEY = "true";
          AUTH_COOKIE_SECURE = "true";
          NEXT_PUBLIC_BASE_URL = "https://${userconf.aiDom}";
          OMNIROUTE_TRUST_PROXY = "loopback";
        };
      };

      services.nginx.virtualHosts.${userconf.aiDom} = {
        forceSSL = true;
        enableACME = true;
        locations."/" = {
          proxyPass = "http://127.0.0.1:20128";
          proxyWebsockets = true;
          extraConfig = ''
            proxy_buffering off;      # SSE streaming
            proxy_read_timeout 3600s;
            allow 192.168.0.0/16;
            allow 127.0.0.1;
            allow ::1;
            deny all;
          '';
        };
      };
    };
}
