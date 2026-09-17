{ self, ... }:
{
  flake.nixosModules.fingerprint =
    { userconf, pkgs, ... }:
    {
      services.fprintd.enable = true;
      security.pam.services.hyprlock.fprintAuth = false;
      home-manager.users.${userconf.username}.imports = [ self.homeModules.fingerprint ];
    };

  flake.homeModules.fingerprint =
    { ... }:
    {
      programs.hyprlock.settings.auth.fingerprint = {
        enabled = true;
        ready_message = "Scan fingerprint";
        present_message = "Scanning…";
        retry_delay = 250;
      };
    };
}
