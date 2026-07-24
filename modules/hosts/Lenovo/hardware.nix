{ self, inputs, ... }:

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

      #boot.kernel.sysctl = {
      #  "net.ipv6.conf.all.disable_ipv6" = 1;
      #  "net.ipv6.conf.default.disable_ipv6" = 1;
      #  "net.ipv6.conf.lo.disable_ipv6" = 1;
      #};

      nixpkgs.hostPlatform = lib.mkDefault "x86_64-linux";
      hardware.cpu.intel.updateMicrocode = lib.mkDefault config.hardware.enableRedistributableFirmware;
    };
}
