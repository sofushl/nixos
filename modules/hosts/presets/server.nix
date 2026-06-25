{ self, ... }:

{
  flake.nixosModules.serverPreset =

    { userconf, ... }:

    {
      imports = with self.nixosModules; [
        base
        user
        server

        develop

        # Services
        nextcloudServer
        dnsUpdater
        gitSites
        discordBot
      ];

      home-manager.users.${userconf.username}.imports = with self.homeModules; [
        dev
        git
        yazi
        neovim
        fastfetch
      ];

      boot.loader = {
        systemd-boot.enable = true;
        efi.canTouchEfiVariables = true;
      };

      system.stateVersion = userconf.state;

      powerManagement.cpuFreqGovernor = "powersave";
    };
}
