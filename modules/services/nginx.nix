{
  self,
  inputs,
  userconf,
  ...
}:

{
  flake.nixosModules.nginx = {
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
      };
    };
  };
}
