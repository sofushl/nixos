{
  self,
  inputs,
  ...
}:

{
  flake.nixosModules.nginx =
    { userconf, ... }:
    {
      services.nginx = {
        enable = true;
        recommendedProxySettings = true;
        recommendedTlsSettings = true;
        recommendedGzipSettings = true;

        virtualHosts = {
          ${userconf.cloudDom} = {
            forceSSL = true;
            enableACME = true;
          };

          ${userconf.secondaryDom} = {
            forceSSL = true;
            enableACME = true;
            globalRedirect = userconf.topDom;
          };

          #${userconf.aiDom} = {
          #  forceSSL = true;
          #  enableACME = true;

          #  locations."/" = {

          #    proxyPass = "http://127.0.0.1:4180";

          #    proxyWebsockets = true; # needed if you need to use WebSocket
          #    extraConfig =
          #      # required when the target is also TLS server with multiple hosts
          #      "proxy_ssl_server_name on;"
          #      +
          #        # required when the server wants to use HTTP Authentication
          #        "proxy_pass_header Authorization;";
          #  };
          #};

          #${userconf.searchDom} = {
          #  forceSSL = true;
          #  enableACME = true;
          #};
        };
      };
    };
}
