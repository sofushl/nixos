{
  flake.homeModules.fastfetch = { userconf, ... }: {
    programs.fastfetch = {
      enable = true;

      settings = {
        logo = {
          type = "file";
          source = "/${userconf.path}/dotfiles/abacordlogo.txt";
          padding.right = 4;
          printRemaining = true;
        };

        display = {
          separator = ": ";
          disableLinewrap = true;
          brightColor = false;
          color = {
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
            key = "{#blue}OS";
          }

          {
            type = "host";
            keyIcon = "󰌢";
            key = "{#blue}Host";
          }

          {
            type = "kernel";
            keyIcon = "";
            key = "{#blue}Kernel";
          }

          {
            type = "uptime";
            keyIcon = "";
            key = "{#blue}Uptime";
          }

          {
            type = "packages";
            keyIcon = "󰏖";
            key = "{#blue}Packages";
          }

          {
            type = "shell";
            keyIcon = "";
            key = "{#blue}Shell";
          }

          "break"

          {
            type = "display";
            keyIcon = "󰍹";
            key = "{#magenta}Display";
          }

          {
            type = "de";
            keyIcon = "";
            key = "{#magenta}DE";
          }

          {
            type = "wm";
            keyIcon = "";
            key = "{#magenta}WM";
          }

          {
            type = "wmtheme";
            keyIcon = "󰓸";
            key = "{#magenta}WMTheme";
          }

          {
            type = "theme";
            keyIcon = "󰉼";
            key = "{#magenta}Theme";
          }

          {
            type = "icons";
            keyIcon = "";
            key = "{#magenta}Icons";
          }

          {
            type = "cursor";
            keyIcon = "󰆿";
            key = "{#magenta}Cursor";
          }

          {
            type = "terminal";
            keyIcon = "";
            key = "{#magenta}Terminal";
          }

          "break"

          {
            type = "cpu";
            keyIcon = "";
            key = "{#green}CPU";
          }

          {
            type = "gpu";
            keyIcon = "󰾲";
            key = "{#green}GPU";
          }

          {
            type = "memory";
            keyIcon = "";
            key = "{#green}Memory";
          }

          {
            type = "swap";
            keyIcon = "󰓡";
            key = "{#green}Swap";
          }

          {
            type = "disk";
            keyIcon = "";
            key = "{#green}Disk";

            showExternal = true;
            showRegular = true;
          }

          {
            type = "battery";
            keyIcon = "";
            key = "{#green}Battery";
          }

          {
            type = "poweradapter";
            keyIcon = "󰚥";
            key = "{#green}Power";
          }
        ];
      };
    };
  };
}
