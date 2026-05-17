{ self, inputs, ... }:

{
  flake.nixosModules.AcerPreservation =
    { userconf, ... }:

    {
      preservation.preserveAt."/persistent" = {
        directories = [
          {
            directory = "/var/lib/nixos";
            inInitrd = true;
          }

          "/etc/nixos"
          "/var/lib/bluetooth"
          "/var/lib/systemd"
          "/var/lib/NetworkManager"
          "/etc/NetworkManager"
          "Documents"
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
            ".ssh"
            ".nextcloud"
            ".local/share/keyrings"
          ];
        };
      };
    };
}
