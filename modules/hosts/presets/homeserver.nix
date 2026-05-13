{ selv, inputs, ... }:

{
  flake.nixosModules.homeserverPreset =

    { userconf, ... }:

    {
      imports = with self.nixosModules; [
        base
        user
        server

        develop
        nextcloud
      ];

      home-manager.users.${userconf.username} = {

        home.username = userconf.username;
        home.stateVersion = userconf.state;
        home.homeDirectory = "/home/${userconf.username}";

        imports = with self.homeModules; [
          neovim
          git
        ];

      };

      # Bootloader
      boot.loader = {
        systemd-boot.enable = true;
        efi.canTouchEfiVariables = true;
      };

      system.stateVersion = userconf.state;

      powerManagement.cpuFreqGovernor = "powersave";
    };
}
