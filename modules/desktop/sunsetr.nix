{
  flake.homeModules.sunsetr =
    { pkgs, ... }:
    let
      tomlFormat = pkgs.formats.toml { };
    in
    {
      home.packages = [ pkgs.sunsetr ];

      xdg.configFile."sunsetr/sunsetr.toml".source = tomlFormat.generate "sunsetr.toml" {
        backend = "wayland";
        transition_mode = "finish_by";

        smoothing = true;
        startup_duration = 0.5;
        shutdown_duration = 0.5;
        adaptive_interval = 1;

        day_gamma = 101;
        day_temp = 6000;
        night_gamma = 60;
        night_temp = 2000;

        update_interval = "auto";

        sunset = "22:00:00";
        sunrise = "06:00:00";
        transition_duration = 60;
      };

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
