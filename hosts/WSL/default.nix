{ userconf, lib, ... }:

{
  imports = [
    <nixos-wsl/modules>

    ../../modules/base.nix
    ../../modules/user.nix

    ../../modules/system/develop.nix

    # ../../modules/impermanence.nix

    # inputs.impermanence.nixosModules.impermanence
  ];

  home-manager.users.${userconf.username} = {

    home.username = userconf.username;
    home.stateVersion = userconf.state;
    home.homeDirectory = "/home/${userconf.username}";

    imports = [
      ../../modules/home/neovim.nix
    ];

  };

  networking.hostName = "WSL";
  networking.resolvconf.enable = lib.mkForce false;

  wsl = {
    enable = true;
    defaultUser = userconf.username;
    startMenuLaunchers = true;
  };

  system.stateVersion = userconf.state;

}
