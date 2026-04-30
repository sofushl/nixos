{ pkgs, ... }:

{

  # Plasma setup
  services = {
    displayManager.plasma-login-manager.enable = true;
    desktopManager.plasma6.enable = true;
  };

  environment = {

    systemPackages = with pkgs; [
      nextcloud-client
      vesktop
      spotify
      scenebuilder
      geteduroam
      librewolf
      loupe
    ];

    plasma6.excludePackages = with pkgs.kdePackages; [
      discover
      elisa
      okular
      khelpcenter
      kinfocenter
      kate
      gwenview
    ];
  };
}
