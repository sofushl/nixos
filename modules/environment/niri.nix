{ self, inputs, ... }:

{
  flake.nixosModules.niri =
    {
      pkgs,
      userconf,
      lib,
      ...
    }:
    {
      imports = [
        inputs.niri.nixosModules.niri
      ];

      nixpkgs.overlays = [ inputs.niri.overlays.niri ];

      home-manager.users.${userconf.username}.imports = [ self.homeModules.niri ];

      programs.niri = {
        enable = true;
        package = pkgs.niri;
      };
      # Fallback for xwayland-sattelite
      xdg.icons.fallbackCursorThemes = [ "Bibata-Modern-Classic" ];
      environment = {
        systemPackages = with pkgs; [

          # Environment applications
          waybar
          fuzzel
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
        ];

        sessionVariables = {
          XCURSOR_THEME = "Bibata-Modern-Classic";
          XCURSOR_SIZE = "24";
          XDG_CURRENT_DESKTOP = "niri";
        };
      };
    };

  flake.homeModules.niri = { pkgs, ... }: {

    xdg = {
      enable = true;

      configFile = {
        "sunsetr/sunsetr.toml".source = ../../dotfiles/sunsetr.toml;
        "niri/config.kdl".source = ../../dotfiles/niri.kdl;
        "waybar".source = ../../dotfiles/waybar; # https://man.archlinux.org/man/waybar.5
        "fuzzel/fuzzel.ini".source = ../../dotfiles/fuzzel.ini;
        "hypr/hyprlock.conf".source = ../../dotfiles/hyprlock.conf;
      };

      portal = {
        enable = true;
        extraPortals = [
          pkgs.xdg-desktop-portal-gtk
          pkgs.xdg-desktop-portal-wlr
          pkgs.xdg-desktop-portal-gnome
        ];
        config.common.default = [ "gtk" ];
      };
    };

    programs.niri.settings = null;

    gtk = {
      enable = true;
      colorScheme = "dark";

      gtk3 = {
        enable = true;
        extraConfig.gtk-application-prefer-dark-theme = true;
        colorScheme = "dark";
      };

      gtk4 = {
        enable = true;
        extraConfig.gtk-application-prefer-dark-theme = true;
        colorScheme = "dark";
      };
    };

    home.pointerCursor = {
      name = "Bibata-Modern-Classic";
      gtk.enable = true;
      x11.enable = true;
      size = 24;
      package = pkgs.bibata-cursors;
    };

    dconf.settings = {
      "org/gnome/desktop/interface" = {
        color-scheme = "prefer-dark";
      };
    };

  };
}
