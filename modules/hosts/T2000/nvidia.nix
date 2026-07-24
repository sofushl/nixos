{
  flake.nixosModules.nvidia =
    { config, ... }:
    {
      nixpkgs.config.allowUnfree = true;

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
