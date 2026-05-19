{ self, inputs, ... }:

{
  flake.nixosModules.tmpfsDisk =
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

          {
            directory = "/etc/ssh";
            inInitrd = true;
          }

          "/etc/nixos"
          "/etc/NetworkManager/system-connections"
          #"/etc/cups"

          "/var/lib/bluetooth"
          "/var/lib/systemd/timers"
          "/tmp"

        ];

        files = [
          {
            file = "/etc/machine-id";
            inInitrd = true;
          }
        ];

        users.${userconf.username} = {
          directories = [

            "Downloads"
            "nixos"

            ".ssh"
            ".nextcloud"

            ".config/VSCodium"

            ".librewolf"

            ".local/share/keyrings"
            ".local/state/wireplumber"

          ];
          files = [
            # "Documents"
          ];
        };
      };

      fileSystems."/nix".neededForBoot = true;

      disko.devices.nodev = {
        "/" = {
          fsType = "tmpfs";
          mountOptions = [
            "size=25%"
            "mode=755"
          ];
        };
      };

      disko.devices.disk.main = {
        device = "/dev/${userconf.disk}";
        type = "disk";

        content.type = "gpt";

        content.partitions.esp = {
          priority = 1;
          name = "ESP";
          start = "1M";
          end = "128M";
          type = "EF00";
          content = {
            type = "filesystem";
            format = "vfat";
            mountpoint = "/boot";
            mountOptions = [ "umask=0077" ];
          };
        };

        content.partitions.swap = {
          size = "8G";

          content = {
            type = "swap";
            resumeDevice = true;
          };
        };

        content.partitions.root = {
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
