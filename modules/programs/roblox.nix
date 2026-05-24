{ self, inputs, ... }:

{
  flake.nixosModules.roblox =
    { userconf, pkgs, ... }:
    {
      services.flatpak = {
        enable = true;
        packages = [
          "org.vinegarhq.Sober"
        ];
      };
    };
}
