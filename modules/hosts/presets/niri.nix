{ self, inputs, ... }:

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

        imports = [
          /${userconf.path}/home/neovim.nix
          /${userconf.path}/home/git.nix

          /${userconf.path}/home/librewolf.nix
          /${userconf.path}/home/darkmode.nix

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
