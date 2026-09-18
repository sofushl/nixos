{ inputs, ... }:
{
  flake.nixosModules.preservation =
    { userconf, config, ... }:
    {

      imports = [ inputs.preservation.nixosModules.default ];

      preservation.enable = true;

      zramSwap = {
        enable = true;
        algorithm = "zstd";
        memoryPercent = 20;
        priority = 2;
      };

      swapDevices = [
        {
          device = "/persistent/swapfile";
          size = 16 * 1024;
          priority = 1;
        }
      ];

      preservation.preserveAt."/tmp" = {
        users.${userconf.username} = {
          directories = [ ".cache" ];
        };
      };

      systemd.tmpfiles.rules = [
        "R! /home/sofushl/.cache - - - - -"
        "R! /persistent/home/sofushl/.cache - - - - -"
      ];

      preservation.preserveAt."/persistent" = {
        directories = [
          {
            directory = "/var/lib";
            inInitrd = true;
          }
          "/etc/nixos"
          "/etc/ssh"
          (if config.networking.networkmanager.enable == true then "/etc/NetworkManager" else "")
        ];

        files = [
          {
            file = "/etc/machine-id";
            inInitrd = true;
          }
        ];

        users.${userconf.username} = {
          directories = [
            "nixos"
            ".ssh"
            ".local/share/keyrings"
          ];

          files = [
            ".bash_history"
          ];
        };
      };
    };
}
