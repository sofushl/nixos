{
  pkgs,
  userconf,
  ...
}:

{

  programs.niri = {
    enable = true;
    useNautilus = false;
  };

  xdg = {
    portal = {
      wlr.enable = true;
      enable = true;
      extraPortals = [
        pkgs.xdg-desktop-portal-gtk
        pkgs.xdg-desktop-portal-wlr
      ];
    };
    # Fallback for xwayland-sattelite
    icons.fallbackCursorThemes = [ "Bibata-Modern-Classic" ];

    mime.defaultApplications = {
      "inode/directory" = [ "cosmic-files.desktop" ];
    };
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
            rightcontrol = "layer(meta)";
            capslock = "esc";
          };
          nav = {
            h = "left";
            j = "down";
            k = "up";
            l = "right";
            rightalt = "compose";
            rightcontrol = "rightcontrol";
            capslock = "capslock";
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
      waybar
      fuzzel
      alacritty
      cosmic-files
      hyprlock
      btop
      wl-clipboard

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

      # Launch shellscripts
      (writeShellScriptBin "nvim-home" "alacritty -e bash -lc 'cd ~/Documents && nvim'")
    ];

    variables = {
      XCURSOR_THEME = "Bibata-Modern-Classic";
      XCURSOR_SIZE = "24";
      XDG_CURRENT_DESKTOP = "niri";
    };

  };
}
