{ userconf, ... }:

{
  imports = [
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

  system.stateVersion = userconf.state;

}
