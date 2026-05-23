{ self, inputs, ... }:

{
  flake.nixosModules.ventoyDisk =
    { userconf, ... }:
    {

      boot.tmp.cleanOnBoot = true;

      preservation.enable = true;

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

            "Documents"
            "nixos"

            ".ssh"
            ".local/share/keyrings"

          ];
        };
      };

      fileSystems."/nix".neededForBoot = true;

      disko.devices.nodev.root = {
        fsType = "tmpfs";

        mountpoint = "/";

        mountOptions = [
          "size=25%"
          "mode=755"
        ];
      };

      disko.devices.disk.main = {
        device = "/dev/${userconf.disk}";
        type = "disk";

        content.type = "gpt";

        content.partitions.esp = {
          size = "200M";
          type = "EF00";
          content = {
            type = "filesystem";
            format = "vfat";
            mountpoint = "/boot";
            mountOptions = [ "umask=0077" ];
          };
        };

        content.partitions.ventoy = {
          end = "-20G";
          content = {
            type = "filesystem";
            format = "vfat";
          };
        };

        content.partitions.nixos = {
          name = "root";
          size = "100%";

          content = {
            type = "btrfs";
            extraArgs = [ "-f" ];

            subvolumes = {
              "/persistent" = {
                mountOptions = [
                  "subvol=persistent"
                  "compress=zstd"
                  "noatime"
                ];
                mountpoint = "/persistent";
              };

              "/nix" = {
                mountOptions = [
                  "subvol=nix"
                  "compress=zstd"
                  "noatime"
                ];
                mountpoint = "/nix";
              };
            };
          };
        };
      };
    };
}
