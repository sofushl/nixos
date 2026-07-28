{ inputs, ... }:
{
  flake.nixosModules.minecraftServers =
    { pkgs, ... }:
    let

      inherit (inputs.nix-minecraft.lib) collectFilesAt;

      adrenaline = pkgs.fetchPackwizModpack {
        url = "https://raw.githack.com/intergrav/Adrenaline/main/versions/fabric/26.2/pack.toml";
        packHash = "";
        side = "server";
      };

      worldedit = pkgs.fetchurl {
        url = "https://cdn.modrinth.com/data/1u6JkXh5/versions/j2w3GmPv/worldedit-mod-7.4.4.jar?mr_download_reason=standalone&mr_loader=fabric";
        hash = "";
      };
    in
    {

      imports = [ inputs.nix-minecraft.nixosModules.minecraft-servers ];
      nixpkgs.overlays = [ inputs.nix-minecraft.overlay ];

      services.minecraft-servers = {
        enable = true;
        eula = true;
        openFirewall = true;

        servers.survival = {
          enable = true;
          package = pkgs.fabricServers.fabric-26_2;
          jvmOpts = "-Xms1G -Xmx10G";
          symlinks."mods" = "${adrenaline}/mods";
          files = collectFilesAt adrenaline "config";

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

        servers.creative = {
          enable = true;
          package = pkgs.fabricServers.fabric-26_2;
          jvmOpts = "-Xms1G -Xmx10G";

          whitelist = {
            Sofudge = "001c8e90-4e3e-4b82-91e0-f3f3c2b7d1d3";
          };

          serverProperties = {
            server-port = 25566;
            gamemode = 1;
            allow-cheats = true;
            motd = "Creative minecraft server";
            white-list = true;
            simulation-distance = 32;
            spawn-protection = 0;
            view-distance = 128;
          };
          # collectFilesAt instead of a whole-dir symlink, so worldedit can be added
          symlinks = collectFilesAt adrenaline "mods" // {
            "mods/worldedit.jar" = worldedit;
          };
          files = collectFilesAt adrenaline "config";
        };
      };
    };
}
