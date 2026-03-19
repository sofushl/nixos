{ config, pkgs, ... }:

{
  environment.systemPackages = [ pkgs.alacritty ];

  environment.etc."librewolf/policies/policies.json".text = ''
    {
      "policies": {
        "Preferences": {
          "ui.systemUsesDarkTheme": {
            "Value": 1,
            "Status": "locked"
          },
          "browser.display.background_color": {
            "Value": "#1E1E1E",
            "Status": "locked"
          },
          "browser.display.foreground_color": {
            "Value": "#E0E0E0",
            "Status": "locked"
          },
          "browser.anchor_color": {
            "Value": "#DC6666",
            "Status": "locked"
          },
          "widget.non-native-theme.enabled": {
            "Value": true,
            "Status": "locked"
          },
          "toolkit.legacyUserProfileCustomizations.stylesheets": {
            "Value": true,
            "Status": "locked"
          }
        }
      }
    }
  '';
}
