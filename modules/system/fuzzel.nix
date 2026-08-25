{
  flake.homeModules.fuzzel =
    { userconf, lib, ... }:
    let
      c = userconf.theme;

      hex = c: lib.removePrefix "#" c;
    in
    {

      programs.fuzzel = {
        enable = true;
        settings = {
          main = {
            prompt = ''"$"'';
            dpi-aware = "yes";
            icons = true;
            width = 40;
            terminal = "${userconf.terminal} -a '{cmd}' -T '{cmd}' {cmd}";
            lines = 20;
            horizontal-pad = 8;
            font = "monospace:size=10";
            anchor = "top";
            y-margin = 10;
          };

          colors = {
            background = "${hex c.bg.primary}ff";
            text = "${hex c.text.primary}ff";
            match = "${hex c.primary}ff";
            selection = "${hex c.bg.selected}ff";
            selection-text = "${hex c.text.selected}ff";
            border = "${hex c.primary}ff";
          };

          border = {
            width = 2;
            radius = 8;
          };
        };
      };
    };
}
