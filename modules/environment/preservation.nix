{ self, inputs, ... }:

{
  flake.nixosModules.preservation =
    { userconf, ... }:
    {

      preservation.enable = true;

      preservation.preserveAt."/persistent" = {
        directories = [
          {
            directory = "/var/lib/nixos";
            inInitrd = true;
          }
          "/etc/nixos"
          "/var/lib/bluetooth"
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
          ];
        };
      };
    };
}
