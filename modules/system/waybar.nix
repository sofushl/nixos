{
  flake.homeModules.waybar =
    { pkgs, userconf, ... }:
    let
      term = userconf.terminal;
    in
    {
      programs.waybar = {
        enable = true;

        settings = {
          mainBar = {
            layer = "bottom";
            position = "bottom";
            height = 15;
            margin-top = 0;
            margin-left = 0;
            margin-right = 0;

            modules-left = [ "clock" ];
            modules-center = [ "niri/window" ];
            modules-right = [
              "network"
              "pulseaudio"
              "backlight"
              "temperature"
              "memory"
              "battery"
            ];

            clock = {
              format = "{:%R - %d/%m/%y}";
              format-alt = "{:%R - %A %U}";
              tooltip = false;
            };

            battery = {
              interval = 60;
              format = "BAT {capacity}%";
              on-click = "shutdown now";
              format-time = "{H}:{m}";
              format-full = "CHARGED";
              format-charging = "POW {capacity}%";
              format-plugged = "POW {capacity}%";
            };

            memory = {
              format = "RAM {percentage}%";
              interval = 3;
              on-click = "shutdown -r now";
            };

            pulseaudio = {
              format = "VOL {volume}%";
              format-muted = "MUTED";
              on-click = "${term} -e ${pkgs.wiremix}/bin/wiremix";
            };

            backlight = {
              format = "LUX {percent}%";
              on-click = "sunsetr stop";
              min-brightness = 0.02;
              scroll-step = 0.1;
            };

            network = {
              format-wifi = "{essid}";
              format-ethernet = "ETHERNET";
              format-linked = "LINKED";
              format-disconnected = "OFFLINE";
              format-disabled = "DISABLED";
              tooltip = true;
              tooltip-format = "▼{bandwidthDownBits} ▲{bandwidthUpBits}";
              enable-wireless = true;
              enable-wired = true;
              on-click = "${term} -e nmtui";
              interval = 3;
            };

            temperature = {
              hwmon-path = [
                "/sys/class/hwmon/hwmon4/temp1_input"
                "/sys/class/hwmon/hwmon3/temp1_input"
                "/sys/class/thermal/thermal_zone1/temp"
                "/sys/class/thermal/thermal_zone0/temp"
                # Append or rearrange after necessity
              ];
              format = "CPU {temperatureC}°C";
              interval = 3;
              on-click = "${term} -e ${pkgs.btop}/bin/btop";
            };

            "niri/window" = {
              format = "{title}";
              icon = true;
              icon-size = 12;
              separate-outputs = true;
            };
          };
        };

        style =
          let
            c = userconf.theme;
          in
          ''
            * {
                border: none;
                border-radius: 0;
                font-family: JetbrainsMono Nerd Font;
                font-size: 12px;
                min-height: 0;
                background: ${c.bg.primary};
                color: ${c.text.primary};
            }

            window#waybar {
                
            }

            #clock,
            #memory,
            #pulseaudio,
            #backlight,
            #network,
            #battery,
            #temperature,
            #window {
                padding: 0 5px;
                margin: 1px 3px;
            }

            #pulseaudio,
            #backlight,
            #memory,
            #network,
            #battery,
            #temperature {
                border-bottom: 2px solid ${c.primary};
                min-width: 30px;
            }

            #pulseaudio.muted,
            #network.disabled,
            #network.disconnected,
            #network.linked,
            #network.ethernet,
            #battery.full {
                color: ${c.text.selected};
                background: ${c.bg.selected};
            }

          '';

      };
    };
}
