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
    preservation.preserveAt."/persistent" = {
      directories = [ "var/lib/flatpak" ];
      users.${userconf.username}.directories = [
        ".local/share/flatpak"
        ".var/"
      ];
    };
  };
}
