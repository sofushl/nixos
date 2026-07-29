{ inputs, ... }:
{
  flake.nixosModules.minecraftServer =

    # REQUIRES PRESERVATION OF "/var/lib/minecraft"

    { pkgs, ... }:
    {
      nixpkgs.overlays = [ inputs.nix-minecraft.overlay ];

      services.minecraft-server = {
        enable = true;
        eula = true;
        openFirewall = true;
        declarative = true;

        package = pkgs.purpur-server;
        jvmOpts = "-Xms100M -Xmx10G";

        whitelist = {
          Sofudge = "001c8e90-4e3e-4b82-91e0-f3f3c2b7d1d3";
        };

        serverProperties = {
          difficulty = 3;
          gamemode = 2;
          max-players = 1;
          motd = "Excore minecraft server";
          white-list = true;
          allow-cheats = false;
          simulation-distance = 32;
          spawn-protection = 0;
          view-distance = 128;
        };
      };
    };
}
