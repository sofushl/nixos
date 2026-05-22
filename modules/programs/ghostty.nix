{ self, inputs, ... }:

{
  flake.nixosModules.ghostty =
    { userconf, ... }:

    {
      home-manager.users.${userconf.username}.programs.ghostty = {
        enable = true;
        enableBashIntegration = true;

        settings = {
          theme = "basic-red";
          confirm-close-surface = false;
        };

        themes = {

          basic-red = {
            background = "1E1E1E";
            cursor-color = "DC6666";
            foreground = "D9D9D9";

            palette = [
              "0=#1E1E1E" # black
              "1=#DC6666" # red
              "2=#86B895" # green
              "3=#E0B879" # yellow
              "4=#7DAAEA" # blue
              "5=#CFA1E8" # magenta
              "6=#7FCAC3" # cyan
              "7=#D9D9D9" # white

              "8=#4A4A4A" # bright black
              "9=#E07A7A" # bright red
              "10=#9BCFA9" # bright green
              "11=#E8C890" # bright yellow
              "12=#95BDF0" # bright blue
              "13=#D9B3EE" # bright magenta
              "14=#98D8D2" # bright cyan
              "15=#F0F0F0" # bright white
            ];

            selection-background = "DC6666";
            selection-foreground = "1E1E1E";
          };

        };
      };
    };
}
