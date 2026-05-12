{ userconf, ... }:

{
  imports = [
    ../../modules/base.nix
    ../../modules/desktop.nix
    ../../modules/user.nix

    ../../modules/system/develop.nix

    ../../modules/system/vscodium.nix
    ../../modules/system/eduroam.nix
    ../../modules/system/niri.nix
    ../../modules/system/greetd-niri.nix
    ../../modules/system/keyd.nix

    # ../../modules/impermanence.nix

    # inputs.impermanence.nixosModules.impermanence
  ];

  home-manager.users.${userconf.username} = {

    home.username = userconf.username;
    home.stateVersion = userconf.state;
    home.homeDirectory = "/home/${userconf.username}";

    imports = [
      ../../modules/home/neovim.nix
      ../../modules/home/git.nix

      ../../modules/home/librewolf.nix
      ../../modules/home/darkmode.nix

    ];

  };

  system.stateVersion = userconf.state;

  powerManagement.cpuFreqGovernor = "powersave";
}
