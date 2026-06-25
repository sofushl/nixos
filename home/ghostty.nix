{
  programs.ghostty = {
    enable = true;
    enableBashIntegration = false;

    settings = {
      theme = "basic-red";
      confirm-close-surface = false;
    };

    themes = {

      basic-red = {

        foreground = "#E3E0E0";
        background = "#1E1E1E";
        cursor-color = "#DC6666";

        palette = [
          "0=#1E1E1E" # black
          "7=#E3E0E0" # white

          "1=#DC6666" # red
          "6=#DC6666" # cyan

          #"2=#86B895" # green
          #"3=#E0B879" # yellow
          #"4=#7DAAEA" # blue
          #"5=#CFA1E8" # magenta

          "8=#1E1E1E" # bright black
          "15=E3E0E0" # bright white

          "9=#DC6666" # bright red
          "10=#DC6666" # bright green
          "11=#DC6666" # bright yellow
          "12=#DC6666" # bright blue
          "13=#DC6666" # bright magenta
          "14=#DC6666" # bright cyan
        ];

        selection-background = "DC6666";
        selection-foreground = "1E1E1E";
      };

    };
  };
}
