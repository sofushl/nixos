{ userconf, ... }:

{
  imports = [
    ../../modules/base.nix
    ../../modules/user.nix
    ../../modules/server.nix

    ../../modules/system/develop.nix
    ../../modules/system/nextcloud.nix

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
    ];

  };

  # Bootloader
  boot.loader = {
    systemd-boot.enable = true; # false on WSL
    efi.canTouchEfiVariables = true;
  };

  system.stateVersion = userconf.state;

  powerManagement.cpuFreqGovernor = "powersave";
}
