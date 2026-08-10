{
  flake.nixosModules.hardware =
    {
      config,
      lib,
      pkgs,
      modulesPath,
      ...
    }:

    {
      imports = [
        (modulesPath + "/installer/scan/not-detected.nix")
      ];

      boot = {
        loader = {
          systemd-boot.enable = true;
          systemd-boot.configurationLimit = 5;
          efi.canTouchEfiVariables = true;
        };

        kernelModules = [ "kvm-intel" ];

        initrd.availableKernelModules = [
          "vmd"
          "xhci_pci"
          "ehci_pci"
          "ahci"
          "nvme"
          "usb_storage"
          "sd_mod"
          "rtsx_pci_sdmmc"
        ];

        initrd.kernelModules = [ ];
        extraModulePackages = [ ];
        kernelParams = [ ];
      };

      nixpkgs.hostPlatform = lib.mkDefault "x86_64-linux";
      hardware.cpu.intel.updateMicrocode = lib.mkDefault config.hardware.enableRedistributableFirmware;
    };
}
