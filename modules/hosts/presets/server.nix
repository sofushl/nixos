{ self, inputs, ... }:

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

      home-manager.users.${userconf.username}.imports = [
        ../../../home/dev.nix
        ../../../home/git.nix
        ../../../home/yazi.nix
        ../../../home/neovim.nix
        ../../../home/fastfetch.nix
      ];

      boot.loader = {
        systemd-boot.enable = true;
        efi.canTouchEfiVariables = true;
      };

      system.stateVersion = userconf.state;

      powerManagement.cpuFreqGovernor = "powersave";
    };
}
