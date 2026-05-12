{ userconf, pkgs, ... }:
# Automatic login greeter
{
  services.greetd = {
    enable = true;
    settings.default_session = {
      command = "${pkgs.dbus}/bin/dbus-run-session ${pkgs.niri}/bin/niri";
      user = userconf.username;
    };
  };
}
