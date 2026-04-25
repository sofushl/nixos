{ config, pkgs, ... }:
let
  home-manager = builtins.fetchTarball "https://github.com/nix-community/home-manager/archive/master.tar.gz";
in
{
  imports = [
    (import "${home-manager}/nixos")
    ../dotfiles/alacritty.nix

  ];

  home-manager.users.sofushl = {
    # The home.stateVersion option does not have a default and must be set
    home.stateVersion = "18.09";
    # Here goes the rest of your home-manager config, e.g. home.packages = [ pkgs.foo ];

    #WIP
  };

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
}
