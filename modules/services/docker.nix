{ self, ... }: {
  flake.nixosModules.docker =
    { pkgs, userconf, ... }:

    # REQUIRES PERSISTENT "~/.local/share/docker" (images + volumes)

    {
      virtualisation.docker.rootless = {
        enable = true;
        setSocketVariable = true;
        daemon.settings = {
          # Avoid clashing with the 172.28.7.0/24 subnet compose files pin.
          default-address-pools = [
            {
              base = "172.17.0.0/16";
              size = 24;
            }
          ];
        };
      };

      environment.systemPackages = with pkgs; [
        docker
        docker-compose
        gnumake
      ];

      home-manager.users.${userconf.username}.imports = [ self.homeModules.docker ];
    };

  flake.homeModules.docker = {
    programs.docker-cli.enable = true;
    programs.lazydocker.enable = true;
  };
}
