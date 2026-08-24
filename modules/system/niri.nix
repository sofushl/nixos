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
      home-manager.users.${userconf.username}.imports = with self.homeModules; [
        niri
      ];

      programs.niri.enable = true;

      # Fallback for xwayland-sattelite
      xdg.icons.fallbackCursorThemes = [ "Bibata-Modern-Classic" ];
    };

  flake.homeModules.niri =
    {
      pkgs,
      lib,
      userconf,
      ...
    }:

    let
      c = userconf.theme;
      mkMenu =
        menu:
        let
          configFile = pkgs.writeText "config.yaml" (
            pkgs.lib.generators.toYAML { } {
              anchor = "center";
              background = c.bg.primary;
              color = c.text.primary;

              border = c.primary;
              border_width = 5;
              padding = 10;

              inherit menu;
            }
          );
        in
        pkgs.writeShellScriptBin "my-menu" ''
          exec ${pkgs.lib.getExe pkgs.wlr-which-key} ${configFile}
        '';

      term = "kitty";
    in
    {

      imports = with self.homeModules; [
        inputs.niri.homeModules.niri
        waybar
        kitty
        hyprlock
      ];

      services.mako = {
        enable = true;
        settings = {
          "actionable=true" = {
            anchor = "top-left";
            default-timeout = 3000;
            ignore-timeout = "1";
          };
          actions = true;
          anchor = "top-right";
          background-color = c.bg.primary;
          text-color = c.text.primary;
          border-color = c.primary;
          progress-color = "over ${c.primary}";
          border-size = 2;
          border-radius = 0;
          default-timeout = 3000;
          font = "monospace 10";
          height = 100;
          icons = true;
          ignore-timeout = "1";
          layer = "top";
          margin = 10;
          padding = 10;
          markup = true;
          width = 300;
        };
      };

      xdg = {
        enable = true;

        configFile = {
          "sunsetr/sunsetr.toml".source = ../../dotfiles/sunsetr.toml;
          "fuzzel/fuzzel.ini".source = ../../dotfiles/fuzzel.ini;
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

      gtk =
        let
          gtkConf = {
            extraConfig.gtk-application-prefer-dark-theme = true;

            extraCss = ''
              @define-color accent_color ${c.primary}; 
              @define-color accent_bg_color ${c.bg.selected};
              @define-color accent_fg_color ${c.text.primary};
            '';
          };
        in
        {
          enable = true;
          colorScheme = "dark";

          gtk3 = gtkConf;
          gtk4 = gtkConf;
        };

      home = {
        packages = with pkgs; [

          # Environment applications
          fuzzel
          wl-clipboard
          wlr-which-key

          # Environment controllers
          bluetui
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
          XDG_CURRENT_DESKTOP = "niri";
        };
      };

      dconf = {
        enable = true;
        settings = {
          "org/gnome/desktop/interface" = {
            color-scheme = "prefer-dark";
            accent-color = c.primary;
          };
        };
      };

      programs.niri = {
        enable = true;
        package = pkgs.niri;

        settings = {
          input = {
            keyboard.xkb = {
              layout = "no";
              variant = "nodeadkeys";
            };
            touchpad = {
              tap = true;
              drag = true;
              drag-lock = true;
              scroll-method = "two-finger";
            };
            warp-mouse-to-focus.enable = true;
            focus-follows-mouse.max-scroll-amount = "0%";
          };

          cursor = {
            theme = "Bibata-Modern-Classic";
            size = 20;
            hide-when-typing = true;
          };

          layout = {
            gaps = 2;
            center-focused-column = "never";
            preset-column-widths = [
              { proportion = 0.5; }
              { proportion = 1.0; }
            ];
            default-column-width = {
              proportion = 0.5;
            };
            focus-ring = {
              width = 2;
              active.color = c.primary;
              inactive.color = c.inactive;
            };
            shadow = {
              enable = true;
              draw-behind-window = true;
              softness = 30;
              spread = 5;
              offset = {
                x = 0;
                y = 5;
              };
              color = "#0007";
            };
            struts = { };
          };

          prefer-no-csd = true;

          screenshot-path = "~/Pictures/Screenshots/Screenshot from %Y-%m-%d %H-%M-%S.png";

          spawn-at-startup = [
            { command = [ "waybar" ]; }
            { command = [ "sunsetr" ]; }
            { command = [ "hyprlock" ]; }
            { command = [ "mako" ]; }
          ];

          hotkey-overlay = {
            skip-at-startup = true;
            hide-not-bound = true;
          };

          window-rules = [
            {
              matches = [
                {
                  app-id = "firfox$";
                  title = "^Picture-in-Picture$";
                }
              ];
              open-floating = true;
            }
          ];

          gestures.hot-corners.enable = false;

          switch-events.lid-close.action.spawn = [ "hyprlock" ];

          binds = {
            # Core apps
            "Mod+T".action.spawn = [ term ];
            "Mod+Return".action.spawn = [ term ];
            "Mod+C".action.spawn = [ term ];
            "Mod+Space".action.spawn = [ "fuzzel" ];
            "Mod+R".action.spawn = [ "fuzzel" ];

            # Personal apps
            "Mod+Shift+T".action.spawn = [
              term
              "-e"
              "yazi"
            ];
            "Mod+D".action.spawn = [
              term
              "-e"
              "yazi"
            ];
            "Mod+E".action.spawn = [
              term
              "-e"
              "yazi"
            ];
            "Mod+B".action.spawn = [ "firefox" ];
            "Mod+F".action.spawn = [ "firefox" ];
            "Mod+S".action.spawn = [
              (pkgs.lib.getExe (mkMenu [
                {
                  key = "a";
                  desc = "Launcher";
                  cmd = (lib.getExe pkgs.fuzzel);
                }
                {
                  key = "s";
                  desc = "Spotify";
                  cmd = (lib.getExe pkgs.spotify);
                }
                {
                  key = "d";
                  desc = "Discord";
                  cmd = (lib.getExe pkgs.discord);
                }
                {
                  key = "f";
                  desc = "Onlyoffice";
                  cmd = (lib.getExe pkgs.onlyoffice-desktopeditors);
                }
                {
                  key = "g";
                  desc = "Element";
                  cmd = (lib.getExe pkgs.element-desktop);
                }
                {
                  key = "h";
                  desc = "Postman";
                  cmd = (lib.getExe pkgs.postman);
                }
                {
                  key = "k";
                  desc = "Thonny";
                  cmd = (lib.getExe pkgs.thonny);
                }
                {
                  key = "l";
                  desc = "Loupe";
                  cmd = (lib.getExe pkgs.loupe);
                }
              ]))
            ];

            # Window control
            "Mod+Q".action.close-window = { };

            # Column navigation
            "Mod+H".action.focus-column-left = { };
            "Mod+L".action.focus-column-right = { };
            "Mod+Shift+H".action.move-column-left = { };
            "Mod+Shift+L".action.move-column-right = { };
            "Mod+Aring".action.focus-column-first = { };
            "Mod+Diaeresis".action.focus-column-last = { };
            "Mod+Shift+Aring".action.move-column-to-first = { };
            "Mod+Shift+Diaeresis".action.move-column-to-last = { };

            # Inside columns
            "Mod+Shift+J".action.move-window-down = { };
            "Mod+Shift+K".action.move-window-up = { };
            "Mod+J".action.focus-window-down = { };
            "Mod+K".action.focus-window-up = { };
            "Mod+Shift+U".action.consume-or-expel-window-left = { };
            "Mod+Shift+I".action.consume-or-expel-window-right = { };

            # Special Column movements
            "Mod+A".action.maximize-column = { };
            "Mod+Shift+A".action.set-window-width = "50%";
            "Mod+M".action.expand-column-to-available-width = { };
            "Mod+Shift+M".action.maximize-window-to-edges = { };
            "Mod+X".action.center-column = { };
            "Mod+Shift+X".action.reset-window-height = { };

            # Finer height and width adjustments
            "Mod+Minus".action.set-column-width = "-10%";
            "Mod+Plus".action.set-column-width = "+10%";
            "Mod+Shift+Minus".action.set-window-height = "-10%";
            "Mod+Shift+Plus".action.set-window-height = "+10%";

            # Move the focused window between the floating and the tiling layout.
            "Mod+V".action.toggle-window-floating = { };
            "Mod+Shift+V".action.switch-focus-between-floating-and-tiling = { };

            # Toggle tabbed column display mode.
            # Windows in this column will appear as vertical tabs,
            # rather than stacked on top of each other.
            "Mod+W".action.toggle-column-tabbed-display = { };

            "Print".action.screenshot = { };
            "Ctrl+Print".action.screenshot-screen = { };
            "Alt+Print".action.screenshot-window = { };

            # Applications such as remote-desktop clients and software KVM switches may
            # request that niri stops processing the keyboard shortcuts defined here
            # so they may, for example, forward the key presses as-is to a remote machine.
            # It's a good idea to bind an escape hatch to toggle the inhibitor,
            # so a buggy application can't hold your session hostage.
            "Mod+Escape" = {
              allow-inhibiting = false;
              action.toggle-keyboard-shortcuts-inhibit = { };
            };

            # The quit action will show a confirmation dialog to avoid accidental exits.
            "Mod+Shift+E".action.quit = { };
            "Ctrl+Alt+Delete".action.quit = { };

            # Audio
            "XF86AudioRaiseVolume" = {
              allow-when-locked = true;
              action.spawn-sh = "wpctl set-volume @DEFAULT_AUDIO_SINK@ 0.1+ -l 1.0";
            };
            "XF86AudioLowerVolume" = {
              allow-when-locked = true;
              action.spawn-sh = "wpctl set-volume @DEFAULT_AUDIO_SINK@ 0.1-";
            };
            "XF86AudioMute" = {
              allow-when-locked = true;
              action.spawn-sh = "wpctl set-mute @DEFAULT_AUDIO_SINK@ toggle";
            };
            "XF86AudioMicMute" = {
              allow-when-locked = true;
              action.spawn-sh = "wpctl set-mute @DEFAULT_AUDIO_SOURCE@ toggle";
            };

            # Brightness
            "XF86MonBrightnessUp" = {
              allow-when-locked = true;
              action.spawn = [
                "brightnessctl"
                "--class=backlight"
                "set"
                "5%+"
              ];
            };
            "XF86MonBrightnessDown" = {
              allow-when-locked = true;
              action.spawn = [
                "brightnessctl"
                "--class=backlight"
                "set"
                "1"
              ];
            };

            # Player
            "XF86AudioPlay" = {
              allow-when-locked = true;
              action.spawn-sh = "playerctl play-pause";
            };
            "XF86AudioStop" = {
              allow-when-locked = true;
              action.spawn-sh = "playerctl stop";
            };
            "XF86AudioPrev" = {
              allow-when-locked = true;
              action.spawn-sh = "playerctl previous";
            };
            "XF86AudioNext" = {
              allow-when-locked = true;
              action.spawn-sh = "playerctl next";
            };

            # Sleep
            "XF86Sleep".action.spawn = [
              "hyprlock"
              "power-off-monitors"
            ];

            "Mod+Shift+W".action.spawn = [
              "hyprlock"
            ];
          };

        };
      };
    };
}
