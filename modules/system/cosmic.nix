# REQUIRES HOME AND NIXOS IMPORT "cosmic"

{
  flake.nixosModules.cosmic =
    {
      config,
      lib,
      pkgs,
      userconf,
      ...
    }:
    {
      services.desktopManager.cosmic.enable = true;
      services.desktopManager.cosmic.xwayland.enable = true;
      services.displayManager.cosmic-greeter.enable = true;

      services.desktopManager.cosmic.showExcludedPkgsWarning = false;

      environment = {
        sessionVariables.COSMIC_DATA_CONTROL_ENABLED = "1";
        cosmic.excludePackages = with pkgs; [
          cosmic-initial-setup
          cosmic-term
        ];
      };
    };
}
