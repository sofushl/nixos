{ self, inputs, ... }:

{
  flake.nixosModules.gitSites =
    {
      userconf,
      pkgs,
      lib,
      ...
    }:
    let
      sites = [
        {
          name = "homepage";
          root = "/dist";
          repo = "https://github.com/sofushl/homepage.git";
          domain = userconf.topDom;
        }
      ]
      ++ userconf.secretPages;

      pack = with pkgs; [
        git
        nodejs
        bash
      ];

    in
    {
      environment.systemPackages = pack;

      systemd.services.git-site-update = {
        path = pack;

        script = ''
          mkdir -p /var/www

          ${lib.concatMapStringsSep "\n" (site: ''

            if [ ! -d /var/www/${site.name}/.git ]; then
              git clone ${site.repo} /var/www/${site.name}
            else
              git -C /var/www/${site.name} fetch origin
              git -C /var/www/${site.name} reset --hard origin/HEAD
            fi

            cd /var/www/${site.name}
            if [ -f package.json ]; then
              npm install
              npm run build
            fi

          '') sites}
        '';

        serviceConfig.Type = "oneshot";
      };

      systemd.timers.git-site-update = {
        wantedBy = [ "timers.target" ];

        timerConfig = {
          OnStartupSec = "2m";
          OnUnitActiveSec = "20m";
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
          };
        }) sites
      );

      preservation.preserveAt.directories = [ "/var/www" ];
    };
}
