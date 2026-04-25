{ config, pkgs, ... }:

{

  services.displayManager.sddm = {
    enable = true;
    theme = "breeze";
  }
  # Plasma setup
  services.desktopManager.plasma6.enable = true;
  environment.plasma6.excludePackages = with pkgs.kdePackages; [
    discover
    elisa
    kate
    gwenview
    okular
    khelpcenter
    kinfocenter
  ];
}
