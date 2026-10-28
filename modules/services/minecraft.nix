{ inputs, ... }:
{
  flake.nixosModules.minecraftServer =

    # REQUIRES PRESERVATION OF "/var/lib/minecraft/"

    {
      pkgs,
      lib,
      userconf,
      ...
    }:
    let
      githubDatapacks = {
        achievementcomp = pkgs.fetchFromGitHub {
          owner = "sofushl";
          repo = "achievementcomp";
          rev = "v1.0.0";
          hash = "sha256-L4mhN3uwUGvcdNgUXC3UrFx7dFJjXNoXSnrTV2VTpRY=";
        };
      };
    in
    {
      imports = [ inputs.nix-minecraft.nixosModules.minecraft-servers ];
      nixpkgs.overlays = [ inputs.nix-minecraft.overlay ];

      services.minecraft-servers = {
        enable = true;
        eula = true;
        openFirewall = true;
        dataDir = "/var/lib/minecraft";
        user = "minecraft";
        group = "minecraft";

        managementSystem.tmux = {
          enable = true;
          socketPath = name: "/run/minecraft/${name}.sock";
        };

        servers.main = {
          enable = true;
          autoStart = false;
          package = pkgs.purpur-server;
          jvmOpts = userconf.minecraft.jvmOpts12;

          serverProperties = {
            level-seed = 7702654185421006115;
            difficulty = 3;
            gamemode = 2;
            max-players = 100;
            motd = "Abellan minecraft server";
            white-list = false;

            world-border = 1500;
            simulation-distance = 5;
            spawn-protection = 0;
            view-distance = 16;

            enforce-secure-profile = false;

            player-idle-timeout = 0;
            entity-broadcast-range-percentage = 100;
            sync-chunk-writes = false;
          };

          symlinks = lib.mapAttrs' (n: v: lib.nameValuePair "world/datapacks/${n}" v) githubDatapacks;
        };
      };

      systemd.services.minecraft-server.serviceConfig = userconf.minecraft.prioServiceConfig;
    };
}
