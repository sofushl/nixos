{ self, ... }:

{
  flake.nixosModules.laptopPreset =
    { userconf, ... }:

    {
      imports = with self.nixosModules; [
        base
        desktop
        user
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
        nextcloudClient
        flatpak
      ];

      home-manager.users.${userconf.username}.imports = with self.homeModules; [
        dev
        git
        yazi
        neovim
        fastfetch
        firefox
      ];

      preservation.preserveAt."/persistent".directories = [
        "/var/lib/bluetooth"
        "/var/lib/flatpak"
      ];

      preservation.preserveAt."/persistent".users.${userconf.username}.directories = [
        ".local/share/flatpak"
        ".var/"
        ".config/mozilla"
        ".nextcloud"
        ".config/Nextcloud"
        "Downloads"
      ];

      system.stateVersion = userconf.state;

      powerManagement.cpuFreqGovernor = "powersave";
    };
}
