{ config, pkgs, userconf, ... }:

{
  programs.niri.enable = true;

  # Display manager
  services.xserver.enable = true;
  xdg.portal = {
    wlr.enable = true;
    enable = true;
    extraPortals = [ pkgs.xdg-desktop-portal-wlr ];
  };

  # Bad but nice automatic login greeter
  services.greetd = {
    enable = true;
    settings.default_session = {
      command = ''
        ${pkgs.dbus}/bin/dbus-run-session ${pkgs.niri}/bin/niri
      '';
      user = userconf.username;
    };
  };
  
  #services.displayManager.defaultSession = "niri";
  #services.xserver.displayManager.lightdm = {
  #  enable = true;
  #  greeters.enso.enable = true;
  #};

  environment.variables = {
    XCURSOR_THEME = "Bibata-Modern-Classic";
    XCURSOR_SIZE = "24";
  };

  # fallback for xwayland-sattelite
  xdg.icons.fallbackCursorThemes = [ "Bibata-Modern-Classic" ];

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

  environment.etc."niri/config.kdl".source = ./config/niri.kdl;
  environment.etc."xdg/waybar".source = ./config/waybar; # https://man.archlinux.org/man/waybar.5
  environment.etc."xdg/fuzzel/fuzzel.ini".source = ./config/fuzzel.ini;
  environment.etc."alacritty/alacritty.toml".source = ./config/alacritty.toml;
  environment.etc."fastfetch".source = ./config/fastfetch;
  # doesnt work: environment.etc."sunsetr/sunsetr.toml".source = ./config/sunsetr.toml;

  environment.systemPackages = with pkgs; [

    # Environment applications
    cosmic-files
    waybar
    fuzzel
    alacritty
    fastfetch

    # Environment controllers
    pavucontrol
    playerctl
    brightnessctl
    networkmanagerapplet
    sunsetr

    # Customization
    bibata-cursors

    # X11 support for niri
    xwayland-satellite

    #USB disk management
    usbutils
    udiskie
  ];

}
