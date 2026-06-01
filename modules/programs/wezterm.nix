{ self, inputs, ... }:

{
  flake.nixosModules.wezterm =
    { userconf, ... }:

    {

      home-manager.users.${userconf.username}.programs.wezterm = {
        enable = true;

        enableBashIntegration = true;
        enableZshIntegration = true;

        colorSchemes.basic-red = {
          foreground = "#E3E0E0";
          background = "#1E1E1E";

          cursor_bg = "#DC6666";
          cursor_fg = "#1E1E1E";
          cursor_border = "#DC6666";

          selection_bg = "#DC6666";
          selection_fg = "#1E1E1E";

          ansi = [
            "#1E1E1E" # black
            "#DC6666" # red
            "#86B895" # green
            "#E0B879" # yellow
            "#7DAAEA" # blue
            "#CFA1E8" # magenta
            "#DC6666" # cyan
            "#E3E0E0" # white
          ];

          brights = [
            "#1E1E1E" # bright black
            "#DC6666" # bright red
            "#86B895" # green
            "#E0B879" # yellow
            "#7DAAEA" # blue
            "#CFA1E8" # magenta
            "#DC6666" # bright cyan
            "#E3E0E0" # bright white
          ];
        };

        settings = {
          color_scheme = "basic-red";

          # Ghostty-like minimal UI
          window_decorations = "NONE";
          hide_tab_bar_if_only_one_tab = true;
          use_fancy_tab_bar = false;
          enable_scroll_bar = false;

          # Similar feel
          window_padding = {
            left = 4;
            right = 4;
            top = 0;
            bottom = 0;
          };

          line_height = 0.9;
          cell_width = 1.0;

          # Ghostty doesn't ask before closing either
          window_close_confirmation = "NeverPrompt";

          adjust_window_size_when_changing_font_size = false;
        };
      };
    };
}
