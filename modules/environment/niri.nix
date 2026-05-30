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

      nixpkgs.overlays = [ inputs.niri.overlays.niri ];

      programs.niri = {
        enable = true;
        package = pkgs.niri;
      };

      xdg = {
        portal = {
          wlr.enable = true;
          enable = true;
          extraPortals = [
            pkgs.xdg-desktop-portal-gtk
            pkgs.xdg-desktop-portal-wlr
            pkgs.xdg-desktop-portal-gnome
          ];

          config.common.default = [ "*" ];
        };

        # Fallback for xwayland-sattelite
        icons.fallbackCursorThemes = [ "Bibata-Modern-Classic" ];
      };
      environment = {

        # Config imports
        etc = {
          "niri/config.kdl".source = ../../dotfiles/niri.kdl;
          "xdg/waybar".source = ../../dotfiles/waybar; # https://man.archlinux.org/man/waybar.5
          "xdg/fuzzel/fuzzel.ini".source = ../../dotfiles/fuzzel.ini;
          "xdg/hypr/hyprlock.conf".source = ../../dotfiles/hyprlock.conf;
        };

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
          # Launch shellscripts
          (writeShellScriptBin "term" "ghostty -e bash -lc 'cd ~/'")
        ];

        sessionVariables = {
          XCURSOR_THEME = "Bibata-Modern-Classic";
          XCURSOR_SIZE = "24";
          XDG_CURRENT_DESKTOP = "niri";
        };
      };

      home-manager.users.${userconf.username} = {

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

        dconf.settings = {
          "org/gnome/desktop/interface" = {
            color-scheme = "prefer-dark";
          };
        };

        xdg = {
          enable = true;

          configFile."sunsetr/sunsetr.toml" = {
            source = ../../dotfiles/sunsetr.toml;
            force = true;
          };

          portal = {
            enable = true;
            extraPortals = [
              pkgs.xdg-desktop-portal-gtk
              pkgs.xdg-desktop-portal-wlr
            ];
            config.common.default = [ "gtk" ];
          };
        };
      };
    };
}
