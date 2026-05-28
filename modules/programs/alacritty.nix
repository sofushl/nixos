{ self, inputs, ... }:

{
  flake.nixosModules.alacritty =
    { userconf, ... }:

    {
      home-manager.users.${userconf.username}.programs.alacritty = {
        enable = true;

        settings = {
          window = {
            decorations = "None";

            padding = {
              x = 5;
              y = 0;
            };
          };

          mouse = {
            hide_when_typing = true;
          };

          colors = {
            primary = {
              background = "#1E1E1E";
              foreground = "#E3E0E0";
            };

            selection = {
              text = "#1E1E1E";
              background = "#DC6666";
            };

            cursor = {
              text = "#E3E0E0";
              cursor = "#DC6666";
            };

            normal = {
              black = "#1E1E1E";
              white = "#E3E0E0";

              red = "#DC6666";

              cyan = "#DC6666";
            };

            bright = {
              black = "#1E1E1E";
              white = "#E3E0E0";

              red = "#DC6666";
              green = "#DC6666";
              yellow = "#DC6666";
              blue = "#DC6666";
              magenta = "#DC66666";
              cyan = "#DC66666";
            };
          };

        };
      };
    };
}
