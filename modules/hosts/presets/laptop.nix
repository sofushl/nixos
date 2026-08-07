{ self, ... }:

{
  flake.nixosModules.laptopPreset =
    { userconf, ... }:

    {
      imports = with self.nixosModules; [
        base
        desktop
        user
        disko
        preservation
        niri

        # Development libraries
        develop
        javafxDev
        icedDev
        micropython

        # Services
        networkmanager
        greetd-niri
        keyd
      ];

      home-manager.users.${userconf.username}.imports = with self.homeModules; [
        fastfetch
        firefox
        rclone
      ];

      preservation.preserveAt."/persistent".directories = [
        "/var/lib/bluetooth"
      ];

      preservation.preserveAt."/persistent".users.${userconf.username} = {
        directories = [
          ".config/mozilla"
          "Downloads"
        ];

        files = [
          ".config/gh/hosts.yml"
          ".config/rclone/nextcloud.pass"
        ];
      };

      powerManagement.cpuFreqGovernor = "powersave";
    };
}
