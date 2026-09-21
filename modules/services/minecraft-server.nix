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
        dataDir = "/var/lib/minecraft";

        package = pkgs.purpur-server;
        jvmOpts = "-Xms12G -Xmx12G -XX:+UseG1GC -XX:+ParallelRefProcEnabled -XX:MaxGCPauseMillis=200 -XX:+UnlockExperimentalVMOptions -XX:+DisableExplicitGC -XX:+AlwaysPreTouch -XX:G1NewSizePercent=40 -XX:G1MaxNewSizePercent=50 -XX:G1HeapRegionSize=16M -XX:G1ReservePercent=15 -XX:G1HeapWastePercent=5 -XX:G1MixedGCCountTarget=4 -XX:InitiatingHeapOccupancyPercent=20 -XX:G1MixedGCLiveThresholdPercent=90 -XX:G1RSetUpdatingPauseTimePercent=5 -XX:SurvivorRatio=32 -XX:+PerfDisableSharedMem -XX:MaxTenuringThreshold=1";

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

      systemd.services.minecraft-server.serviceConfig = {
        CPUWeight = 500;
        IOWeight = 500;
        OOMScoreAdjust = 100;
      };

    };
}
