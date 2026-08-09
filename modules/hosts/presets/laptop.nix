{ self, ... }:

{
  flake.nixosModules.laptopPreset =
    { userconf, ... }:

    {
      imports = with self.nixosModules; [
        default
        desktop
        niri
        boot

        # Development libraries
        javafxDev
        icedDev
        micropython

        # Services
        networkmanager
        greetd-niri
        keyd
      ];

      home-manager.users.${userconf.username}.imports = with self.homeModules; [
        firefox
        rclone
      ];

      preservation.preserveAt."/persistent".directories = [
        "/var/lib/bluetooth"
      ];

      preservation.preserveAt."/persistent".users.${userconf.username} = {
        directories = [
          "Downloads"
          ".config/mozilla"
          ".config/discord"
          ".config/spotify"
          ".config/opencode"
          ".local/share/opencode"
          ".local/state/opencode"
        ];

        files = [
          ".config/gh/hosts.yml"
          ".config/rclone/nextcloud.pass"
        ];
      };

      powerManagement.cpuFreqGovernor = "powersave";
    };
}
