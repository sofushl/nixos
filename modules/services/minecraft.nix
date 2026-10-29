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
      serverName = "comp";

      githubDatapacks = {
        achievementcomp = pkgs.fetchFromGitHub {
          owner = "sofushl";
          repo = "achievementcomp";
          rev = "main";
          hash = lib.fakeHash;
        };
      };

      hocon = pkgs.formats.hocon { };
      bluemapMaps =
        lib.mapAttrs
          (_: dimension: {
            world = "/var/lib/minecraft/${serverName}/world";
            inherit dimension;
          })
          {
            overworld = "minecraft:overworld";
            nether = "minecraft:the_nether";
            end = "minecraft:the_end";
          };

      bluemapPlugin = pkgs.fetchurl {
        url = "https://github.com/BlueMap-Minecraft/BlueMap/releases/download/v5.29/bluemap-5.29-paper.jar";
        hash = "sha256-e/R1k2wmEH1HbGMVHHbVtJ6GXuvq2hLJ59khVd6He58=";
      };
      bluemapConf = {
        "plugins/BlueMap/core.conf" = hocon.generate "core.conf" { accept-download = true; };
        "plugins/BlueMap/webserver.conf" = hocon.generate "webserver.conf" {
          enabled = true;
          ip = "127.0.0.1";
          port = 8100;
        };
        "plugins/BlueMap/storages/file.conf" = hocon.generate "file.conf" {
          storage-type = "FILE";
          root = "bluemap/web/maps";
        };
      }
      // lib.mapAttrs' (
        n: v: lib.nameValuePair "plugins/BlueMap/maps/${n}.conf" (hocon.generate "${n}.conf" v)
      ) bluemapMaps;
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

        servers.${serverName} = {
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

          symlinks =
            lib.mapAttrs' (n: v: lib.nameValuePair "world/datapacks/${n}" v) githubDatapacks
            // bluemapConf
            // {
              "plugins/BlueMap.jar" = bluemapPlugin;
            };
        };
      };

      services.nginx.virtualHosts.${userconf.mcDom} = {
        forceSSL = true;
        enableACME = true;
        locations."/".proxyPass = "http://127.0.0.1:8100";
      };

      systemd.services.minecraft-server.serviceConfig = userconf.minecraft.prioServiceConfig;
    };
}
