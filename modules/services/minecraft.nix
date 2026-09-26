{ self, inputs, ... }:
{
  flake.nixosModules.minecraftServer =

    # REQUIRES PRESERVATION OF "/var/lib/minecraft/"

    { pkgs, ... }:
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
      };
    };
}
