{ config, pkgs, ... }:

{
  programs.niri.enable = true;

  # Display manager
  services.xserver.enable = true;
  services.greetd = {
    enable = true;
    settings.default_session = {
      command = "${pkgs.niri}/bin/niri";
      user = "youruser";
    };
  };
  #services.displayManager.defaultSession = "niri";
  #services.xserver.displayManager.lightdm = {
  #  enable = true;
  #  greeters.enso.enable = true;
  #};

  environment.etc."niri/config.kdl" = {
    source = ./niri.kdl;
  };

  environment.variables = {
    XCURSOR_THEME = "Bibata-Modern-Classic";
    XCURSOR_SIZE = "24";
  };

  xdg.icons.fallbackCursorThemes = [ "Bibata-Modern-Classic" ];

  imports = [
    ./fuzzel.nix
    ./alacritty.nix
    ./librewolf/librewolf.nix
  ];

  #https://man.archlinux.org/man/waybar.5
  environment.etc."xdg/waybar" = {
    source = ./waybar;
  };

  # Audio (PipeWire is standard on NixOS now)
  services.pipewire = {
    enable = true;
    pulse.enable = true;
    alsa.enable = true;
  };

  # Enable networking
  networking.networkmanager.enable = true;

  # USB management
  services.udisks2.enable = true;
  services.gvfs.enable = true;

  programs.waybar.enable = true;
  # Required tools
  environment.systemPackages = with pkgs; [

    # Environment applications
    cosmic-files
    waybar

    # Environment controllers
    pavucontrol
    playerctl
    brightnessctl
    networkmanagerapplet

    # Customization
    bibata-cursors

    # X11 support for niri
    xwayland-satellite

    #USB disk management
    usbutils
    udiskie
  ];

}
