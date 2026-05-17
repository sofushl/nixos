{ self, inputs, ... }:

{
  flake.nixosModules.AcerDisk = {

    fileSystems."/nix".neededForBoot = true;

    disko.devices = {
      nodev."/" = {
        fsType = "tmpfs";

        mountOptions = [
          "size=25%"
          "mode=755"
        ];
      };

      disk.main = {
        type = "disk";
        device = "/dev/nvme0n1";

        content = {

          partitions = {
            nixos = {
              name = "ROOT";
              device = "/dev/nvme0n1p4";

              content = {
                type = "btrfs";

                extraArgs = [ "-f" ];

                subvolumes = {
                  "/persistent" = {
                    mountpoint = "/persistent";
                    mountOptions = [
                      "subvol=persistent"
                      "compress=zstd"
                      "noatime"
                    ];
                  };

                  "/nix" = {
                    mountpoint = "/nix";
                    mountOptions = [
                      "subvol=nix"
                      "compress=zstd"
                      "noatime"
                    ];
                  };
                };
              };
            };
          };
        };
      };
    };

    fileSystems."/boot" = {
      device = "/dev/nvme0n1p1";
      fsType = "vfat";

      options = [
        "fmask=0077"
        "dmask=0077"
      ];
    };
  };
}
