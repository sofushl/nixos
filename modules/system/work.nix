{
  flake.homeModules.work = { lib, pkgs, ... }: {
    programs.hyprlock.enable = lib.mkForce false;

    home.packages = with pkgs; [ teams-for-linux ];

    programs.niri.settings = {

      spawn-at-startup = lib.mkForce [
        { command = [ "waybar" ]; }
        {
          command = [
            "teams-for-linux"
            "--no-sandbox"
          ];
        }
      ];

      binds = {
        "Mod+Ctrl+H".action.focus-monitor-left = { };
        "Mod+Ctrl+L".action.focus-monitor-right = { };
        "Mod+Ctrl+Shift+H".action.move-column-to-monitor-left = { };
        "Mod+Ctrl+Shift+L".action.move-column-to-monitor-right = { };
        "Mod+Ctrl+Shift+Aring".action.move-workspace-to-monitor-left = { };
        "Mod+Ctrl+Shift+Diaeresis".action.move-workspace-to-monitor-right = { };
        "Mod+Bar".action.toggle-overview = { };
      };

      outputs = {
        "eDP-1" = {
          position = {
            x = 0;
            y = 0;
          };
          scale = 1.25;
        };

        "DP-2".scale = 1.2;

        "HDMI-A-1".scale = 2;

        "DP-8".position = {
          x = 1536;
          y = 0;
        };

        "DP-9".position = {
          x = 3456;
          y = 0;
        };
      };
    };

    home.shellAliases =
      let
        dir = "/home/soli/Desktop/";
      in
      {
        "launch" = ''
          sudo chown root:root ${dir}launcher/node_modules/electron/dist/chrome-sandbox
          sudo chmod 4755 ${dir}launcher/node_modules/electron/dist/chrome-sandbox
          ${dir}launcher/node_modules/electron/dist/electron  ${dir}launcher --ozone-platform=wayland --enable-features=UseOzonePlatform
        '';

        "pack" = ''
          tarball=$(cd ${dir}shared && npm pack --pack-destination ${dir}shared --ignore-scripts | grep -E '\.tgz$')
          npm i --save-dev "${dir}shared/$tarball"
          npm run build:dev
        '';

      };

    programs.npm = {
      enable = true;
      package = pkgs.nodejs_22;
    };
  };
}
