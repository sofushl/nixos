{ self, inputs, ... }:

{
  # Automatic login greeter
  flake.nixosModules.greetd-niri =
    {
      userconf,
      pkgs,
      ...
    }:
    {
      services.greetd = {
        enable = true;
        settings.default_session = {
          command = "${pkgs.dbus}/bin/dbus-run-session ${pkgs.niri}/bin/niri";
          user = userconf.username;
        };
      };
    };
}
