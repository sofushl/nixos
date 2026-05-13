{ selv, inputs, ... }:

{
  flake.nixosModules.niriPreset =
    { userconf, ... }:

    {
      imports = with self.nixosModules; [
        base
        desktop
        user

        develop

        vscodium
        eduroam
        niri
        greetd-niri
        keyd
      ];

      home-manager.users.${userconf.username} = {

        home.username = userconf.username;
        home.stateVersion = userconf.state;
        home.homeDirectory = "/home/${userconf.username}";

        imports = with self.homeModules; [
          neovim
          git

          librewolf
          darkmode

        ];

      };

      boot.loader = {
        systemd-boot.enable = true;
        efi.canTouchEfiVariables = true;
      };

      system.stateVersion = userconf.state;

      powerManagement.cpuFreqGovernor = "powersave";
    };
}
