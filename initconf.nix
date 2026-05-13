{
  imports = [
    ./hardware-configuration.nix
  ];

  boot.loader.systemd-boot.enable = true;
  boot.loader.efi.canTouchEfiVariables = true;

  networking.networkmanager.enable = true;

  console.keyMap = "no";

  users.users.root.initialPassword = "p";

  users.users.sofushl = {
    isNormalUser = true;
    extraGroups = [
      "wheel"
      "networkmanager"
    ];
    initialPassword = "p";
  };

  programs = {

    neovim = {
      enable = true;
      defaultEditor = true;
      viAlias = true;
      vimAlias = true;
    };

    git.enable = true;

    nix-ld.enable = true;
  };

  system.stateVersion = "25.11";

}
