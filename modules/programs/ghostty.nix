{
  flake.homeModules.ghostty = {
    programs.ghostty = {
      enable = true;
      settings = {
        window-decoration = "none";
        window-padding-x = 4;
        window-padding-y = 0;
        window-show-tab-bar = "auto";
        gtk-titlebar = false;
        gtk-wide-tabs = false;
        confirm-close-surface = false;
        adjust-cell-height = "-10%";

        keybind = [ "super+w=close_tab" ];

        palette = [
          "0=#1E1E1E"
          "1=#DC6666"
          "2=#86B895"
          "3=#E0B879"
          "4=#7DAAEA"
          "5=#CFA1E8"
          "6=#7FC0C4"
          "7=#E3E0E0"
          "8=#3A3A3A"
          "9=#E87878"
          "10=#98C9A6"
          "11=#EDC98C"
          "12=#93BCF5"
          "13=#DCB3F2"
          "14=#92D0D4"
          "15=#F2F0F0"
        ];
        background = "#1E1E1E";
        foreground = "#E3E0E0";
        cursor-color = "#DC6666";
        cursor-text = "#1E1E1E";
        selection-background = "#DC6666";
        selection-foreground = "#1E1E1E";
      };
    };
  };
}
