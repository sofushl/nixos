{
  flake.homeModules.workMonitors = { lib, ... }: {
    programs.niri.settings = {

      spawn-at-startup = lib.mkForce [
        { command = [ "waybar" ]; }
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
        "DP-2" = {
          scale = 1;
        };
        "DP-8" = {
          position = {
            x = 1536;
            y = 0;
          };
        };
        "DP-9" = {
          position = {
            x = 3456;
            y = 0;
          };
        };
      };

    };
  };
}
