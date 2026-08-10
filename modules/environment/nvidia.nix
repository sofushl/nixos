{
  flake.nixosModules.nvidia =
    { config, ... }:
    {
      nixpkgs.config.allowUnfree = true;
      nixpkgs.config.cudaCapabilities = [ "7.5" ];

      nix.settings = {
        substituters = [
          "https://cache.nixos-cuda.org"
          "https://cache.nixos.org"
        ];
        trusted-public-keys = [
          "cache.nixos-cuda.org:74DUi4Ye579gUqzH4ziL9IyiJBlDpMRn9MBN8oNan9M="
          "cache.nixos.org-1:6NCHdD59X431o0gWypbMrAURkbJ16ZPMQFGspcDShjY="
        ];
      };

      services.xserver.videoDrivers = [ "nvidia" ];
      hardware.graphics.enable = true;

      hardware.nvidia = {
        modesetting.enable = true;
        nvidiaSettings = true;
        package = config.boot.kernelPackages.nvidiaPackages.stable;

        open = false;

        powerManagement.enable = true;

        prime = {
          offload.enable = true;
          offload.enableOffloadCmd = true;
          intelBusId = "PCI:0:2:0";
          nvidiaBusId = "PCI:1:0:0";
        };
      };
    };
}
