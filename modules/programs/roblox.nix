{ self, inputs, ... }:

{
  flake.nixosModules.roblox =
    { userconf, ... }:
    {
      services.flatpak = {
        enable = true;
        packages = [
          "org.vinegarhq.Sober"
          "io.gitlab.leesonwai.Sums"
        ];
        remotes = [
          {
            name = "flathub";
            location = "https://flathub.org/repo/flathub.flatpakrepo";
          }
        ];
      };

      preservation.preserveAt."/persistent" = {

        directories = [
          "var/lib/flatpak"
        ];

        users.${userconf.username}.directories = [
          ".local/share/flatpak"
          ".var/app"
        ];

      };
    };
}
