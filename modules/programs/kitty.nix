{
  flake.homeModules.kitty =
    { pkgs, userconf, ... }:
    let
      c = userconf.theme;
    in
    {

      programs.kitty = {
        enable = true;

        shellIntegration.enableBashIntegration = true;

        font.name = "JetBrainsMonoNL NFM Medium";
        font.size = 12;

        settings = {
          hide_window_decorations = true;
          window_padding_width = "0 2";
          confirm_os_window_close = 0;

          modify_font = "cell_height 90%";

          tab_bar_style = "powerline";
          tab_bar_min_tabs = 2;
          tab_bar_edge = "top";

          enable_audio_bell = false;

          background = c.bg.primary;
          foreground = c.text.primary;
          cursor = c.primary;
          cursor_text_color = c.text.selected;
          selection_background = c.bg.selected;
          selection_foreground = c.text.selected;

          active_tab_background = c.bg.primary;
          active_tab_foreground = c.text.primary;
          inactive_tab_background = c.bg.secondary;
          inactive_tab_foreground = c.text.secondary;
          tab_bar_background = c.bg.primary;

          color0 = c.n.black;
          color1 = c.n.red;
          color2 = c.n.green;
          color3 = c.n.yellow;
          color4 = c.n.blue;
          color5 = c.n.magenta;
          color6 = c.n.cyan;
          color7 = c.n.white;
          color8 = c.b.black;
          color9 = c.b.red;
          color10 = c.b.green;
          color11 = c.b.yellow;
          color12 = c.b.blue;
          color13 = c.b.magenta;
          color14 = c.b.cyan;
          color15 = c.b.white;
        };
      };
    };
}
