{ self, inputs, ... }:

{
  flake.nixosModules.roblox =
    { userconf, ... }:
    {
      imports = [
        inputs.nix-flatpak.nixosModules.nix-flatpak
      ];

      services.flatpak = {
        enable = true;
        packages = [
          "org.vinegarhq.Sober"
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
