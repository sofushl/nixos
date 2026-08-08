{ inputs, ... }:
{
  flake.nixosModules.preservation =
    { userconf, ... }:
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

      preservation.preserveAt."/persistent" = {
        directories = [
          {
            directory = "/var/lib/nixos";
            inInitrd = true;
          }
          "/etc/nixos"
          "/etc/ssh"
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
          ];

          files = [
            ".bash_history"
          ];
        };
      };
    };
}
