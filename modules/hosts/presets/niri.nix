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

        neovim
        git
        librewolf
        darkmode
      ];

      boot.loader = {
        systemd-boot.enable = true;
        efi.canTouchEfiVariables = true;
      };

      system.stateVersion = userconf.state;

      powerManagement.cpuFreqGovernor = "powersave";
    };
}
