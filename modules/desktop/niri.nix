# Copyright (C) 2026 Sofus Højberg Lind
# SPDX-License-Identifier: AGPL-3.0-or-later

{ self, ... }:

# REQUIRES HOME AND NIXOS IMPORT "niri"

{
  flake.homeModules.niri =
    {
      pkgs,
      lib,
      userconf,
      ...
    }:

    let
      c = userconf.theme;

      term = userconf.terminal;
      browser = userconf.browser;
      launcher = "fuzzel";
    in
    {

      imports = with self.homeModules; [
        waybar
        hyprlock
        fuzzel
        sunsetr
        mako
        wlrWhichKey
        theme
        xdg
      ];

      home = {
        packages = with pkgs; [
          wl-clipboard
          bluetui
          pavucontrol
          playerctl
          brightnessctl
          bibata-cursors
          nirimon
          nautilus
        ];

        sessionVariables = {
          XDG_CURRENT_DESKTOP = "niri";
          XDG_SESSION_TYPE = "wayland";
          SDL_VIDEODRIVER = "wayland";
        };
      };

      services.blueman-applet.enable = true;

      systemd.user.services.polkit-gnome-authentication-agent-1 = {
        Unit = {
          Description = "polkit-gnome-authentication-agent-1";
          Wants = [ "graphical-session.target" ];
          After = [ "graphical-session.target" ];
        };
        Install = {
          WantedBy = [ "graphical-session.target" ];
        };
        Service = {
          Type = "simple";
          ExecStart = "${pkgs.polkit_gnome}/libexec/polkit-gnome-authentication-agent-1";
          Restart = "on-failure";
          RestartSec = 1;
          TimeoutStopSec = 10;
        };
      };

      wayland.windowManager.niri = {
        enable = true;
        package = pkgs.niri;
        xwaylandSatellitePackage = pkgs.xwayland-satellite;
        portalPackage = pkgs.xdg-desktop-portal-gnome;
        settings = {
          input = {
            keyboard.xkb = {
              layout = "no";
              variant = "nodeadkeys";
            };
            touchpad = {
              tap = { };
              natural-scroll = { };
              drag = true;
              drag-lock = { };
              scroll-method = "two-finger";
            };
            warp-mouse-to-focus = { };
          };

          cursor = {
            xcursor-theme = "Bibata-Modern-Classic";
            xcursor-size = 20;
            hide-when-typing = true;
          };

          layout = {
            gaps = 2;
            center-focused-column = "never";
            preset-column-widths._children = [
              { proportion = 0.5; }
              { proportion = 1.0; }
            ];
            default-column-width.proportion = 0.5;
            focus-ring = {
              width = 2;
              active-color = c.primary;
              inactive-color = c.inactive;
            };
            shadow = {
              on = { };
              draw-behind-window = true;
              softness = 30;
              spread = 5;
              offset._props = {
                x = 0;
                y = 5;
              };
              color = "#0007";
            };
            struts = {
              left = 0;
              right = 0;
              top = 0;
              bottom = 0;
            };
          };

          prefer-no-csd = true;

          screenshot-path = "~/Pictures/Screenshots/Screenshot from %Y-%m-%d %H-%M-%S.png";

          spawn-at-startup = [ (lib.getExe pkgs.hyprlock) ];

          hotkey-overlay = {
            skip-at-startup = true;
            hide-not-bound = true;
          };

          window-rule._children = [
            {
              match._props = {
                app-id = "${browser}$";
                title = "^Picture-in-Picture$";
              };
            }
            { match._props.app-id = "^org\\.testfx\\."; }
            { open-floating = true; }
          ];

          gestures.hot-corners.top-right = { };

          switch-events.lid-close.spawn = [ "hyprlock" ];

          binds = {
            # Core apps
            "Mod+T".spawn = [ term ];
            "Mod+Return".spawn = [ term ];
            "Mod+Space".spawn = [ launcher ];
            "Mod+R".spawn = [ launcher ];
            "Mod+E".spawn = [ launcher ];
            "Mod+B".spawn = [ browser ];
            "Mod+F".spawn = [ browser ];

            # Toggle the laptop screen
            "Mod+N".spawn-sh = "niri msg output eDP-1 on";
            "Mod+Shift+N".spawn-sh = "niri msg output eDP-1 off";

            "Mod+S".spawn = [
              (lib.getExe pkgs.wlr-which-key)
              "apps.yaml"
            ];
            "Mod+D".spawn = [
              (lib.getExe pkgs.wlr-which-key)
              "system.yaml"
            ];

            # Window control
            "Mod+Q".close-window = { };

            # Column navigation
            "Mod+H".focus-column-left = { };
            "Mod+L".focus-column-right = { };
            "Mod+Shift+H".move-column-left = { };
            "Mod+Shift+L".move-column-right = { };
            "Mod+Aring".focus-column-first = { };
            "Mod+Diaeresis".focus-column-last = { };
            "Mod+Shift+Aring".move-column-to-first = { };
            "Mod+Shift+Diaeresis".move-column-to-last = { };

            # Inside columns
            "Mod+Shift+J".move-window-down = { };
            "Mod+Shift+K".move-window-up = { };
            "Mod+J".focus-window-down = { };
            "Mod+K".focus-window-up = { };
            "Mod+Shift+U".consume-or-expel-window-left = { };
            "Mod+Shift+I".consume-or-expel-window-right = { };

            # Special Column movements
            "Mod+A".maximize-column = { };
            "Mod+Shift+A".set-window-width = "50%";
            "Mod+M".maximize-window-to-edges = { };
            "Mod+Shift+M".fullscreen-window = { };
            "Mod+X".center-column = { };
            "Mod+Shift+X".reset-window-height = { };

            # Display+workspace switching
            "Mod+Ctrl+H".focus-monitor-left = { };
            "Mod+Ctrl+L".focus-monitor-right = { };
            "Mod+Ctrl+J".focus-workspace-down = { };
            "Mod+Ctrl+K".focus-workspace-up = { };

            # Display + Workspace movements
            "Mod+Ctrl+Shift+H".move-column-to-monitor-left = { };
            "Mod+Ctrl+Shift+L".move-column-to-monitor-right = { };
            "Mod+Ctrl+Shift+J".move-column-to-workspace-down = { };
            "Mod+Ctrl+Shift+K".move-column-to-workspace-up = { };
            "Mod+Ctrl+U".move-workspace-to-monitor-left = { };
            "Mod+Ctrl+I".move-workspace-to-monitor-right = { };
            "Mod+Bar".toggle-overview = { };

            # Finer height and width adjustments
            "Mod+Minus".set-column-width = "-10%";
            "Mod+Plus".set-column-width = "+10%";
            "Mod+Shift+Minus".set-window-height = "-10%";
            "Mod+Shift+Plus".set-window-height = "+10%";

            # Move the focused window between the floating and the tiling layout.
            "Mod+V".switch-focus-between-floating-and-tiling = { };
            "Mod+Shift+V".toggle-window-floating = { };

            # Toggle tabbed column display mode.
            # Windows in this column will appear as vertical tabs,
            # rather than stacked on top of each other.
            "Mod+W".toggle-column-tabbed-display = { };

            "Print".screenshot = { };
            "Ctrl+Print".screenshot-screen = { };
            "Alt+Print".screenshot-window = { };

            # Applications such as remote-desktop clients and software KVM switches may
            # request that niri stops processing the keyboard shortcuts defined here
            # so they may, for example, forward the key presses as-is to a remote machine.
            # It's a good idea to bind an escape hatch to toggle the inhibitor,
            # so a buggy application can't hold your session hostage.
            "Mod+Escape" = {
              _props.allow-inhibiting = false;
              toggle-keyboard-shortcuts-inhibit = { };
            };

            # The quit action will show a confirmation dialog to avoid accidental exits.
            "Mod+Shift+E".quit = { };
            "Ctrl+Alt+Delete".quit = { };

            # Audio
            "XF86AudioRaiseVolume" = {
              _props.allow-when-locked = true;
              spawn-sh = "wpctl set-volume @DEFAULT_AUDIO_SINK@ 0.05+";
            };
            "XF86AudioLowerVolume" = {
              _props.allow-when-locked = true;
              spawn-sh = "wpctl set-volume @DEFAULT_AUDIO_SINK@ 0.05-";
            };
            "XF86AudioMute" = {
              _props.allow-when-locked = true;
              spawn-sh = "wpctl set-mute @DEFAULT_AUDIO_SINK@ toggle";
            };
            "XF86AudioMicMute" = {
              _props.allow-when-locked = true;
              spawn-sh = "wpctl set-mute @DEFAULT_AUDIO_SOURCE@ toggle";
            };

            # Brightness
            "XF86MonBrightnessUp" = {
              _props.allow-when-locked = true;
              spawn = [
                "brightnessctl"
                "--class=backlight"
                "set"
                "2%+"
              ];
            };
            "XF86MonBrightnessDown" = {
              _props.allow-when-locked = true;
              spawn = [
                "brightnessctl"
                "--class=backlight"
                "set"
                "2%-"
              ];
            };

            # Player
            "XF86AudioPlay" = {
              _props.allow-when-locked = true;
              spawn-sh = "playerctl play-pause";
            };
            "XF86AudioStop" = {
              _props.allow-when-locked = true;
              spawn-sh = "playerctl stop";
            };
            "XF86AudioPrev" = {
              _props.allow-when-locked = true;
              spawn-sh = "playerctl previous";
            };
            "XF86AudioNext" = {
              _props.allow-when-locked = true;
              spawn-sh = "playerctl next";
            };

            # Sleep
            "XF86Sleep".spawn = [
              "hyprlock"
              "power-off-monitors"
            ];

            "Mod+Shift+W".spawn = [
              "hyprlock"
            ];
          };
        };
      };
    };
}
