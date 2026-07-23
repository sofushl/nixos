{
  flake.nixosModules.preservation =
    { userconf, ... }:
    {
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
        };
      };
    };
}
