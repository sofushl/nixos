{ config, ... }:

{
  services.displayManager.cosmic-greeter.enable = true;
  services.desktopManager.cosmic.enable = true;
  services.desktopManager.cosmic.showExcludedPkgsWarning = false;
  hardware.graphics.enable = true;

  environment.cosmic.excludePackages = with pkgs; [
    cosmic-edit
    cosmic-player
    cosmic-store
    cosmic-term
    cosmic-applibrary
    cosmic-bg
    cosmic-wallpapers
    flatpak
    pop-icon-theme

  ];
}
