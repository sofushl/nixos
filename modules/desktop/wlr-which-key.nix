{
  flake.homeModules.wlrWhichKey =
    {
      pkgs,
      lib,
      userconf,
      ...
    }:
    let
      c = userconf.theme;
    in
    {

      programs.wlr-which-key = {
        enable = true;
        package = pkgs.wlr-which-key;

        extraMenus.apps = {
          anchor = "center";
          background = c.bg.primary;
          color = c.text.primary;

          border = c.primary;
          border_width = 5;
          padding = 10;

          menu = [
            {
              key = "a";
              desc = "Element";
              cmd = lib.getExe pkgs.element-desktop;
            }
            {
              key = "s";
              desc = "Spotify";
              cmd = lib.getExe pkgs.spotify;
            }
            {
              key = "d";
              desc = "Vesktop";
              cmd = lib.getExe pkgs.vesktop;
            }
            {
              key = "f";
              desc = "Other";
              submenu = [
                {
                  key = "a";
                  desc = "VLC Media Player";
                  cmd = lib.getExe pkgs.vlc;
                }
                {
                  key = "s";
                  desc = "Loupe";
                  cmd = lib.getExe pkgs.loupe;
                }
                {
                  key = "d";
                  desc = "Waybar";
                  cmd = "${pkgs.systemd}/bin/systemctl --user restart waybar";
                }
                {
                  key = "f";
                  desc = "Sunsetr";
                  cmd = "${pkgs.systemd}/bin/systemctl --user restart sunsetr";
                }
              ];
            }
          ];
        };
      };
    };
}
