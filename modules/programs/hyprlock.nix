{
  flake.homeModules.hyprlock =
    {
      userconf,
      pkgs,
      lib,
      ...
    }:
    let
      c = userconf.theme;
      hex = c: lib.removePrefix "#" c;

      textPrimary = hex c.text.primary;
      primary = hex c.primary;
      bgPrimary = hex c.bg.primary;

      clock = {
        text = ''cmd[update:1000] echo "$(date +'%H:%M')"'';
        color = "rgba(${textPrimary}ff)";
        font_size = 64;
        font_family = "monospace";
        position = "0, 80";
        halign = "center";
        valign = "center";
      };

      date = {
        text = ''cmd[update:10000] echo "$(date +'%A, %d %B %Y')"'';
        color = "rgba(${textPrimary}aa)";
        font_size = 18;
        font_family = "monospace";
        position = "0, 30";
        halign = "center";
        valign = "center";
      };
    in
    {
      programs.hyprlock = {
        enable = true;

        settings = {
          general = {
            disable_loading_bar = true;
            hide_cursor = true;
          };

          label = [
            clock
            date
          ];

          input-field = [
            {
              size = "20%, 5%";
              outline_thickness = 2.5;

              dots_size = 0.3;
              dots_spacing = 0.2;
              dots_center = true;

              outer_color = "rgba(${primary}ff)";
              inner_color = "rgba(${bgPrimary}ff)";
              font_color = "rgba(${textPrimary}ff)";

              fade_on_empty = false;

              position = "0, -80";
              halign = "center";
              valign = "center";
            }
          ];

          background = [
            {
              path = "screenshot";
              blur_passes = 2;
            }
          ];
        };
      };
    };
}
