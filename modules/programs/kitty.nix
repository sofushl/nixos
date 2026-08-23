{
  flake.homeModules.kitty = {
    programs.kitty = {
      enable = true;

      settings = {
        # window
        hide_window_decorations = true;
        window_padding_width = "0 4";
        confirm_os_window_close = 0;
        adjust_line_height = "-10%";

        # tab bar
        tab_bar_style = "powerline";
        tab_bar_min_tabs = 2;

        # scrollback / misc
        enable_audio_bell = false;

        # colors
        background = "#1E1E1E";
        foreground = "#E3E0E0";
        cursor = "#DC6666";
        cursor_text_color = "#1E1E1E";
        selection_background = "#DC6666";
        selection_foreground = "#1E1E1E";

        color0 = "#1E1E1E";
        color1 = "#DC6666";
        color2 = "#86B895";
        color3 = "#E0B879";
        color4 = "#7DAAEA";
        color5 = "#CFA1E8";
        color6 = "#7FC0C4";
        color7 = "#E3E0E0";
        color8 = "#3A3A3A";
        color9 = "#E87878";
        color10 = "#98C9A6";
        color11 = "#EDC98C";
        color12 = "#93BCF5";
        color13 = "#DCB3F2";
        color14 = "#92D0D4";
        color15 = "#F2F0F0";
      };
    };
  };
}
