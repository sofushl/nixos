{
  flake.homeModules.bitwarden =
    { userconf, pkgs, ... }:
    {
      programs.rbw = {
        enable = true;
        package = pkgs.rbw;

        settings = {
          email = userconf.email;
          base_url = "https://${userconf.vaultDom}";
          pinentry = pkgs.pinentry-gnome3;
        };
      };
    };
}
