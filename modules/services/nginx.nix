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
          ${userconf.topDom} = {
            forceSSL = true;
            enableACME = true;

            root = "/var/www/homepage";

            extraConfig = ''
              index index.html;
            '';
          };

          ${userconf.cloudDom} = {
            forceSSL = true;
            enableACME = true;
          };

          ${userconf.secondaryDom} = {
            forceSSL = true;
            enableACME = true;
            globalRedirect = userconf.topDom;
          };

          ${userconf.secretDom} = {
            forceSSL = true;
            enableACME = true;
            root = "/var/www/secretpage";

            extraConfig = ''
              index index.html;
            '';
          };

        };
      };
    };
}
