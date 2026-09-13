{ self, ... }:
{
  flake.nixosModules.fingerprint =
    { userconf, pkgs, ... }:
    {
      services.fprintd.enable = true;

      # Only if lsusb shows Goodix/Broadcom — mainline Synaptics/Elan don't need this:
      # services.fprintd.tod = {
      #   enable = true;
      #   driver = pkgs.libfprint-2-tod1-goodix;   # or libfprint-2-tod1-broadcom
      # };

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
