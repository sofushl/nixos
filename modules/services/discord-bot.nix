{ self, inputs, ... }:

{
  flake.nixosModules.discordBot =
    {
      userconf,
      pkgs,
      lib,
      ...
    }:
    let
      bots = [
        {
          name = "AbaCordium";
          repo = "https://github.com/AbaCord/AbaCordium.git";
        }
      ];

      pack = with pkgs; [
        git
        nodejs
        bash
      ];

    in
    {
      environment.systemPackages = pack;

      systemd.services.discord-bot-update = {
        path = pack;

        script = ''
          mkdir -p /var/www

          ${lib.concatMapStringsSep "\n" (bot: ''

            if [ ! -d /var/www/${bot.name}/.git ]; then
              git clone ${bot.repo} /var/www/${bot.name}
            else
              git -C /var/www/${bot.name} fetch origin
              git -C /var/www/${bot.name} reset --hard origin/HEAD
            fi

            cd /var/www/${bot.name}
            npm update
            npm start

          '') bots}
        '';

        serviceConfig.Type = "oneshot";
      };

      systemd.timers.discord-bot-update = {
        wantedBy = [ "timers.target" ];

        timerConfig = {
          OnBootSec = "1m";
          OnUnitActiveSec = "10m";
        };
      };

      preservation.preserveAt.directories = [ "/var/www" ];
    };
}
