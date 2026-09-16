{ self, ... }:
{
  flake.nixosModules.keyring =
    {
      userconf,
      pkgs,
      lib,
      config,
      ...
    }:
    {
      services.gnome.gnome-keyring.enable = true;
      services.dbus.packages = [ pkgs.gnome-keyring ];

      environment.systemPackages = [
        pkgs.libsecret
        pkgs.seahorse
      ];

      security.pam.services = {
        login.enableGnomeKeyring = true;
        greetd.enableGnomeKeyring = true;
      };

      security.polkit = {
        enable = true;
        enablePkexecWrapper = true;
      };

    };
}
