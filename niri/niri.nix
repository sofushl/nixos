{
  config,
  pkgs,
  userconf,
  ...
}:

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

  # Config imports
  environment.etc = {
    "niri/config.kdl".source = ./config/niri.kdl;
    "xdg/waybar".source = ./config/waybar; # https://man.archlinux.org/man/waybar.5
    "xdg/fuzzel/fuzzel.ini".source = ./config/fuzzel.ini;
    "alacritty/alacritty.toml".source = ./config/alacritty.toml;
    "fastfetch".source = ./config/fastfetch;
    "/etc/xdg/hypr/hyprlock.conf".source = ./config/hyprlock.conf;
  };

  # Makes right alt into a secondary super/mod/windows button
  services.keyd = {
    enable = true;

    keyboards.default = {
      ids = [ "*" ];

      settings = {
        main = {
          compose = "layer(nav)";
          rightcontrol = "leftmeta";
          leftmeta = "overload(meta, fuzzel)";
        };

        nav = {
          h = "left";
          j = "down";
          k = "up";
          l = "right";
          rightalt = "compose";
          rightcontrol = "rightcontrol";
        };
      };
    };
  };
  environment.systemPackages = with pkgs; [

    # Environment applications
    keyd
    cosmic-files
    waybar
    fuzzel
    alacritty
    fastfetch
    hyprlock

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
