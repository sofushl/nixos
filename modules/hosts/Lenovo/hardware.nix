{ selv, inputs, ... }:

{
  flake.nixosModules.LenovoHardware =

    {
      config,
      lib,
      modulesPath,
      ...
    }:

    {
      imports = [
        (modulesPath + "/installer/scan/not-detected.nix")
      ];

      boot.initrd.availableKernelModules = [
        "xhci_pci"
        "ehci_pci"
        "ahci"
        "usb_storage"
        "sd_mod"
        "rtsx_usb_sdmmc"
      ];
      boot.initrd.kernelModules = [ ];
      boot.kernelModules = [ "kvm-intel" ];
      boot.extraModulePackages = [ ];
      boot.kernelParams = [ "intel_pstate=active" ];

      fileSystems."/" = {
        device = "/dev/disk/by-uuid/96002411-4977-4179-afd6-1bf45f4a5a8c";
        fsType = "xfs";
      };

      fileSystems."/boot" = {
        device = "/dev/disk/by-uuid/B3F6-B060";
        fsType = "vfat";
        options = [
          "fmask=0022"
          "dmask=0022"
        ];
      };

      swapDevices = [
        {
          device = "/var/lib/swapfile";
          size = 16 * 1024;
        }
      ];

      nixpkgs.hostPlatform = lib.mkDefault "x86_64-linux";
      hardware.cpu.intel.updateMicrocode = lib.mkDefault config.hardware.enableRedistributableFirmware;
    };
}
