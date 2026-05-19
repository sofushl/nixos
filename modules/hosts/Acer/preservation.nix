{
  self,
  inputs,
  userconf,
  ...
}:

{
  flake.nixosModules.AcerPreservation = {

    boot.tmp.cleanOnBoot = true;

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
        "/etc/cups"

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
          "Documents"
          "nixos"

          ".ssh"
          ".nextcloud"

          ".config/VSCodium"

          ".librewolf"

          ".local/share/keyrings"
          ".loval/state/wireplumber"

        ];
      };
    };
  };
}
