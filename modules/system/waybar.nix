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

            modules-left = [
              "clock"
              "tray"
            ];
            modules-center = [ "niri/window" ];
            modules-right = [
              "network"
              "bluetooth"
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
              states = {
                warning = 30;
                critical = 15;
              };
              format = "{icon} {capacity}%";
              format-charging = "󰂄 {capacity}%";
              format-plugged = "󰚥 {capacity}%";
              format-icons = [
                "󰁺"
                "󰁻"
                "󰁼"
                "󰁽"
                "󰁾"
                "󰁿"
                "󰂀"
                "󰂁"
                "󰂂"
                "󰁹"
              ];
              interval = 60;
              on-click = "shutdown now";
              format-time = "{H}:{m}";
              format-full = "󰁹 {capacity}%";
            };

            memory = {
              format = " {percentage}%";
              interval = 3;
              on-click = "shutdown -r now";
            };

            bluetooth = {
              format = "󰂯 BT";
              format-off = "󰂲 OFF";
              format-disabled = "󰀝 OFF";
              format-connected = "{num_connections}";
              format-connected-battery = "{device_alias}";
              tooltip-format = "{controller_alias}\t{controller_address}";
              tooltip-format-connected = "{controller_alias}\t{controller_address}\n\n{device_enumerate}";
              tooltip-format-enumerate-connected = "{device_alias}\t{device_address}";
              on-click = "blueman-manager";
            };

            pulseaudio = {
              format = "{icon} {volume}%";
              format-muted = "󰝟";
              format-bluetooth = "{volume}%";
              format-bluetooth-muted = "󰝟";
              format-icons = {
                default = [
                  "󰖀"
                  "󰕾"
                ];
                headphone = "󰋋";
                headset = "󰋎";
              };
              on-click = "${term} -e ${pkgs.wiremix}/bin/wiremix";
            };

            backlight = {
              format = "{icon} {percent}%";
              format-icons = [
                "󰃚"
                "󰃛"
                "󰃜"
                "󰃝"
                "󰃞"
                "󰃟"
                "󰃠"
              ];
              on-click = "sunsetr stop";
              min-brightness = 0.02;
              scroll-step = 0.5;
            };

            network = {
              format-wifi = "{essid}";
              format-ethernet = "󰈀 ETH";
              format-linked = "󰅛 {ifname}";
              format-disconnected = "󰖪 OFF";
              format-disabled = "󰀝 OFF";
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
              format = "󰍛 {temperatureC}°C";
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
            #tray,
            #temperature,
            #bluetooth,
            #window {
                padding: 0 5px;
                margin: 1px 3px;
            }

            #pulseaudio,
            #backlight,
            #memory,
            #network,
            #battery,
            #bluetooth,
            #temperature {
                border-bottom: 2px solid ${c.primary};
                min-width: 30px;
            }

            #network.disabled,
            #network.disconnected,
            #network.linked,
            #network.ethernet {
                color: ${c.text.selected};
                background: ${c.bg.selected};
            }

          '';

      };
    };
}
