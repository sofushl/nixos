{ self, inputs, ... }:

{
  flake.nixosModules.fastfetch =
    { userconf, pkgs, ... }:
    {
      home-manager.users.${userconf.username}.programs.fastfetch = {
        enable = true;

        settings = {
          logo = {
            type = "file";
            source = "/etc/fastfetch/abacordlogo.txt";
            padding.right = 4;
            printRemaining = true;
          };

          display = {
            separator = ": ";
            disableLinewrap = true;
            brightColor = false;
            color = {
              keys = "red";
              title = "red";
            };
            key = {
              width = 12;
              type = "both";
            };
          };

          modules = [
            {
              type = "title";
              key = " ";
              keyIcon = "";
            }
            "break"

            {
              type = "os";
              keyIcon = "";
            }

            {
              type = "host";
              keyIcon = "󰌢";
            }

            {
              type = "kernel";
              keyIcon = "";
            }

            {
              type = "uptime";
              keyIcon = "";
            }

            {
              type = "packages";
              keyIcon = "󰏖";
            }

            {
              type = "shell";
              keyIcon = "";
            }

            "break"

            {
              type = "display";
              key = "Display";
              keyIcon = "󰍹";
            }

            {
              type = "de";
              keyIcon = "";
            }

            {
              type = "wm";
              keyIcon = "";
            }

            {
              type = "wmtheme";
              keyIcon = "󰓸";
            }

            {
              type = "theme";
              keyIcon = "󰉼";
            }

            {
              type = "icons";
              keyIcon = "";
            }

            {
              type = "cursor";
              keyIcon = "󰆿";
            }

            {
              type = "terminal";
              keyIcon = "";
            }

            "break"

            {
              type = "cpu";
              keyIcon = "";
              temp = false;
            }

            {
              type = "gpu";
              keyIcon = "󰾲";
            }

            {
              type = "memory";
              keyIcon = "";
            }

            {
              type = "swap";
              keyIcon = "󰓡";
            }

            {
              type = "disk";
              keyIcon = "";
              showExternal = true;
              showRegular = true;
              hideFolders = "/efi:/boot:/boot/*";
              key = "Disk";
            }

            {
              type = "battery";
              key = "Battery";
              keyIcon = "";
            }

            {
              type = "poweradapter";
              keyIcon = "󰚥";
            }

            "break"

            {
              type = "colors";
              key = " ";
              keyIcon = "";
              symbol = "block";
              block = {
                width = 3;
                range = [
                  0
                  15
                ];
              };
            }
          ];
        };
      };

      environment.systemPackages = [ pkgs.fastfetch ];
      environment.etc.fastfetch.source = ../../dotfiles/fastfetch;
    };
}
