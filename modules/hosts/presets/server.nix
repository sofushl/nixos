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
        nginx

        # Programs
        neovim
        git
      ];

      boot.loader = {
        systemd-boot.enable = true;
        efi.canTouchEfiVariables = true;
      };

      system.stateVersion = userconf.state;

      powerManagement.cpuFreqGovernor = "powersave";
    };
}
