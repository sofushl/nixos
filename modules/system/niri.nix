{
  pkgs,
  userconf,
  ...
}:

{

  programs = {
    niri = {
      enable = true;
      useNautilus = false;
    };

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
        command = "${pkgs.dbus}/bin/dbus-run-session ${pkgs.niri}/bin/niri";
        user = userconf.username;
      };
    };

    # USB management
    udisks2.enable = true;
    gvfs.enable = true;

  };

  environment = {

    # Config imports
    etc = {
      "niri/config.kdl".source = ../../dotfiles/niri.kdl;
      "xdg/waybar".source = ../../dotfiles/waybar; # https://man.archlinux.org/man/waybar.5
      "xdg/fuzzel/fuzzel.ini".source = ../../dotfiles/fuzzel.ini;
      "alacritty/alacritty.toml".source = ../../dotfiles/alacritty.toml;
      "fastfetch".source = ../../dotfiles/fastfetch;
      "xdg/hypr/hyprlock.conf".source = ../../dotfiles/hyprlock.conf;
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

    sessionVariables = {
      XCURSOR_THEME = "Bibata-Modern-Classic";
      XCURSOR_SIZE = "24";
      XDG_CURRENT_DESKTOP = "niri";
      QT_STYLE_OVERRIDE = "adwaita-dark";
    };

  };
}
