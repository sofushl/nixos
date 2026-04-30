{ lib, pkgs, ... }:

{

  # Cosmic
  services = {
    displayManager.cosmic-greeter.enable = true;
    desktopManager.cosmic.enable = true;
    desktopManager.cosmic.showExcludedPkgsWarning = false;
  };

  environment = {

    etc = lib.mkIf (!userconf.niri) {
      "alacritty/alacritty.toml".source = ./config/alacritty.toml;
      "fastfetch".source = ./config/fastfetch;
    };

    cosmic.excludePackages = with pkgs; [
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

    systemPackages = with pkgs; [
      nextcloud-client
      onlyoffice-desktopeditors
      vesktop
      spotify
      scenebuilder
      librewolf
      geteduroam
      loupe

    ];
  };
}
