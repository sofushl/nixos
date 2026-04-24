{
  config,
  pkgs,
  userconf,
  ...
}:

{
  programs.niri.enable = true;

  xdg = {
    portal = {
      wlr.enable = true;
      enable = true;
      extraPortals = [ pkgs.xdg-desktop-portal-wlr ];
    };
    # Fallback for xwayland-sattelite
    icons.fallbackCursorThemes = [ "Bibata-Modern-Classic" ];
  };

  # Enable networking
  networking.networkmanager.enable = true;

  services = {

    # Display manager
    xserver = {
      enable = true;
      desktopManager.xterm.enable = false;
      xkb = {
        layout = "no";
        variant = "winkeys";
      };
    };

    # Automatic login greeter
    greetd = {
      enable = true;
      settings.default_session = {
        command = ''
          ${pkgs.dbus}/bin/dbus-run-session ${pkgs.niri}/bin/niri
        '';
        user = userconf.username;
      };
    };

    # Audio
    pipewire = {
      enable = true;
      pulse.enable = true;
      alsa.enable = true;
    };

    # USB management
    udisks2.enable = true;
    gvfs.enable = true;

    # Makes right alt into a secondary super/mod/windows button
    keyd = {
      enable = true;
      keyboards.default = {
        ids = [ "*" ];
        settings = {
          main = {
            compose = "layer(nav)";
            rightcontrol = "leftmeta";
            leftmeta = "overload(leftmeta, fuzzel)";
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
  };

  environment = {

    # Config imports
    etc = {
      "niri/config.kdl".source = ./config/niri.kdl;
      "xdg/waybar".source = ./config/waybar; # https://man.archlinux.org/man/waybar.5
      "xdg/fuzzel/fuzzel.ini".source = ./config/fuzzel.ini;
      "alacritty/alacritty.toml".source = ./config/alacritty.toml;
      "fastfetch".source = ./config/fastfetch;
      "/etc/xdg/hypr/hyprlock.conf".source = ./config/hyprlock.conf;
    };

    systemPackages = with pkgs; [

      # Environment applications
      keyd
      cosmic-files
      waybar
      fuzzel
      alacritty
      fastfetch
      hyprlock
      bluetui
      btop

      # Environment controllers
      pavucontrol
      playerctl
      brightnessctl
      sunsetr

      # Customization
      bibata-cursors

      # X11 support for niri
      xwayland-satellite

      #USB disk management
      usbutils
      udiskie
    ];

    variables = {
      XCURSOR_THEME = "Bibata-Modern-Classic";
      XCURSOR_SIZE = "24";
    };

  };
}
