{
  flake.homeModules.sunsetr =
    { lib, pkgs, ... }:
    let
      tomlFormat = pkgs.formats.toml { };

      baseConfig = {
        backend = "wayland";
        transition_mode = "finish_by";

        smoothing = true;
        startup_duration = 0.5;
        shutdown_duration = 0.5;
        adaptive_interval = 1;

        day_gamma = 100;
        day_temp = 5000;
        night_gamma = 60;
        night_temp = 2000;

        update_interval = "auto";

        sunset = "22:00:00";
        sunrise = "06:00:00";
        transition_duration = 60;
      };

      presets = {
        dark = {
          day_temp = 3000;
          day_gamma = 70;
          night_temp = 1500;
          night_gamma = 40;
        };
        bright = {
          day_temp = 6000;
          day_gamma = 105;
          night_temp = 4000;
          night_gamma = 85;
        };
      };
    in
    {
      home.packages = [ pkgs.sunsetr ];

      xdg.configFile = {
        "sunsetr/sunsetr.toml".source = tomlFormat.generate "sunsetr.toml" baseConfig;
      }
      // lib.mapAttrs' (
        name: overrides:
        lib.nameValuePair "sunsetr/presets/${name}/sunsetr.toml" {
          source = tomlFormat.generate "sunsetr-${name}.toml" (baseConfig // overrides);
        }
      ) presets;

      systemd.user.services.sunsetr = {
        Unit = {
          Description = "sunsetr color temperature";
          PartOf = [ "graphical-session.target" ];
          After = [ "graphical-session.target" ];
        };
        Service = {
          ExecStart = "${pkgs.sunsetr}/bin/sunsetr";
          Restart = "on-failure";
        };
        Install.WantedBy = [ "graphical-session.target" ];
      };
    };
}
