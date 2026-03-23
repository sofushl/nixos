{ config, pkgs, ... }:

{
  # Cosmic greeter as displaymanager
  services.displayManager.cosmic-greeter.enable = true;

  services.desktopManager.cosmic.enable = true;
  services.desktopManager.cosmic.showExcludedPkgsWarning = false;

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

  imports = [
    ./dotfiles/alacritty.nix
  ];
}
