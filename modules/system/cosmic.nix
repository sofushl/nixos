{ self, inputs, ... }: {
  flake.nixosModules.cosmic =
    {
      config,
      lib,
      pkgs,
      userconf,
      ...
    }:
    {
      services.desktopManager.cosmic.enable = true;
      services.desktopManager.cosmic.xwayland.enable = true;
      services.displayManager.cosmic-greeter.enable = true;

      home-manager.users.${userconf.username}.imports = [
        self.homeModules.cosmic
        self.homeModules.ghostty
        inputs.cosmic-manager.homeManagerModules.cosmic-manager
      ];

      services.desktopManager.cosmic.showExcludedPkgsWarning = false;

      environment = {
        sessionVariables.COSMIC_DATA_CONTROL_ENABLED = "1";
        cosmic.excludePackages = with pkgs; [
          cosmic-initial-setup
          cosmic-term
        ];
      };
      programs.firefox.preferences."widget.gtk.libadwaita-colors.enabled" = false;
    };

  flake.homeModules.cosmic =
    { cosmicLib, pkgs, ... }:
    let
      ron = cosmicLib.cosmic.mkRON;
      enum = ron "enum";
      opt = ron "optional";
    in
    {
      xdg = {
        userDirs = {
          enable = true;
          createDirectories = false;
        };

        enable = true;

        portal = {
          enable = true;
          extraPortals = [
            pkgs.xdg-desktop-portal-cosmic
            pkgs.xdg-desktop-portal-wlr
          ];

          config.common.default = "cosmic";
        };
      };

      wayland.desktopManager.cosmic = {
        enable = true;
        resetFiles = true;

        appearance = {
          theme.mode = "dark";
          theme.dark = {
            active_hint = 2;
            gaps = ron "tuple" [
              0
              2
            ];
            accent = opt {
              red = 0.862745;
              green = 0.4;
              blue = 0.4;
            };

            is_frosted = true;

            corner_radii =
              let
                sq = ron "tuple" [
                  0.0
                  0.0
                  0.0
                  0.0
                ];
              in
              {
                radius_0 = sq;
                radius_xs = sq;
                radius_s = sq;
                radius_m = sq;
                radius_l = sq;
                radius_xl = sq;
              };

          };
          toolkit = {
            apply_theme_global = true;
            icon_theme = "Cosmic";
            header_size = enum "Compact";
            interface_density = enum "Compact";

            interface_font = {
              family = "Inter";
              stretch = enum "Normal";
              style = enum "Normal";
              weight = enum "Normal";
            };
            monospace_font = {
              family = "JetBrainsMono Nerd Font";
              stretch = enum "Normal";
              style = enum "Normal";
              weight = enum "Normal";
            };
            show_maximize = true;
            show_minimize = true;
          };
        };

        compositor = {
          active_hint = true;
          autotile = true;
          autotile_behavior = enum "Global";
          focus_follows_cursor = true;
          cursor_follows_focus = false;
          descale_xwayland = false;
          edge_snap_threshold = 0;
          workspaces = {
            workspace_layout = enum "Vertical";
            workspace_mode = enum "OutputBound";
          };
          xkb_config = {
            layout = "no";
            variant = "nodeadkeys";
            model = "";
            rules = "";
            options = opt "terminate:ctrl_alt_bksp";
            repeat_delay = 600;
            repeat_rate = 25;
          };
          input_touchpad = {
            state = enum "Enabled";
            #acceleration = {
            #  profile = opt (enum "Adaptive");
            #  speed = 0.0;
            #};
            click_method = opt (enum "Clickfinger");
            disable_while_typing = opt true;
            #scroll_config.natural_scroll = opt true;
            #tap_config = {
            #  enabled = opt true;
            #  drag = opt true;
            #  drag_lock = opt false;
            #  button_map = opt (enum "LeftRightMiddle");
            #};
          };
        };

        panels = [
          {
            name = "Panel";
            anchor = enum "Bottom";
            anchor_gap = false;
            expand_to_edges = true;
            background = enum "ThemeDefault";
            opacity = 1.0;
            margin = 0;
            size = enum "XS";
            output = enum "All";
            plugins_wings = opt (
              ron "tuple" [
                [
                  "com.system76.CosmicPanelWorkspacesButton"
                  "com.system76.CosmicPanelAppButton"
                ]
                [
                  "com.system76.CosmicAppletStatusArea"
                  "com.system76.CosmicAppletTiling"
                  "com.system76.CosmicAppletAudio"
                  "com.system76.CosmicAppletNetwork"
                  "com.system76.CosmicAppletBattery"
                  "com.system76.CosmicAppletNotifications"
                  "com.system76.CosmicAppletBluetooth"
                  "com.system76.CosmicAppletPower"
                ]
              ]
            );
            plugins_center = opt [ "com.system76.CosmicAppletTime" ];
          }
        ];

        applets.time.settings = {
          military_time = true;
          first_day_of_week = 0;
          show_date_in_top_panel = true;
          show_seconds = false;
          show_weekday = true;
        };

        applets.app-list.settings.favorites = [
          "firefox"
          "com.system76.CosmicFiles"
          "com.system76.CosmicTerm"
        ];

        idle = {
          screen_off_time = opt 300000; # ms
          suspend_on_ac_time = opt 1800000;
          suspend_on_battery_time = opt 600000;
        };

        #wallpapers = [
        #  {
        #    output = "all";
        #    source = enum {
        #      variant = "Path";
        #      value = [ "/home/sofus/wallpapers/main.png" ];
        #    };
        #    scaling_mode = enum "Zoom";
        #    filter_by_theme = true;
        #    rotation_frequency = 600;
        #  }
        #];

        systemActions = ron "map" [
          {
            key = enum "Terminal";
            value = "ghostty";
          }
        ];

        shortcuts = [
          {
            key = "Super+Return";
            action = enum {
              variant = "Spawn";
              value = [ "ghostty" ];
            };
            description = opt "Terminal";
          }
          {
            key = "Super+E";
            action = enum {
              variant = "Spawn";
              value = [ "ghostty start -- yazi" ];
            };
            description = opt "Yazi";
          }
          {
            key = "Super+Q";
            action = enum "Close";
          }
          {
            key = "Super";
            action = enum {
              variant = "System";
              value = [ (enum "Launcher") ];
            };
          }
          {
            key = "Super+Shift+S";
            action = enum {
              variant = "System";
              value = [ (enum "Screenshot") ];
            };
          }
        ];
      };
    };
}
