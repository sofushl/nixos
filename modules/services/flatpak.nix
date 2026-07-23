{
  flake.nixosModules.flatpak = { userconf, ... }: {

    services.flatpak = {
      enable = true;
      packages = [
        "org.vinegarhq.Sober" # Roblox
      ];
      remotes = [
        {
          name = "flathub";
          location = "https://flathub.org/repo/flathub.flatpakrepo";
        }
      ];
    };
  };
}
