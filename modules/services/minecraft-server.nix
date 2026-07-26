{ inputs, ... }:
{
  flake.nixosModules.minecraftServer =
    { userconf, pkgs, ... }:

    {

      imports = [ inputs.nix-minecraft.nixosModules.minecraft-servers ];
      nixpkgs.overlays = [ inputs.nix-minecraft.overlay ];

      services.minecraft-server = {
        jvmOpts = "-Xms4092M -Xmx4092M";
        enable = true;
        eula = true;
        whitelist = {

          Sofudge = "001c8e90-4e3e-4b82-91e0-f3f3c2b7d1d3";
        };

        declarative = true;
        serverProperties = {
          difficulty = 3;
          gamemode = 1;
          max-players = 1;
          motd = "NixOS Minecraft server!";
          white-list = true;
          allow-cheats = false;
        };
        openFirewall = true;
      };
    };
}
