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
        jvmOpts = "-Xms20M -Xmx20G";

        whitelist = {
          Sofudge = "001c8e90-4e3e-4b82-91e0-f3f3c2b7d1d3";
        };

        serverProperties = {
          difficulty = 3;
          gamemode = 2;
          max-players = 100;
          motd = "Abellan minecraft server";
          white-list = false;

          world-border = 100;
          simulation-distance = 5;
          spawn-protection = 0;
          view-distance = 16;

          enforce-secure-profile = false;

          player-idle-timeout = 0;
          entity-broadcast-range-percentage = 100;
          sync-chunk-writes = false;
        };
      };
    };
}
