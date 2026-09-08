{ self, ... }:
{
  flake.nixosConfigurations.init = self.inputs.nixpkgs.lib.nixosSystem {
    system = "x86_64-linux";
    specialArgs.userconf.disk = "nvme0n1";
    modules = with self.nixosModules; [
      disko
      {
        networking.networkmanager.enable = true;
        users.users.root.initialPassword = "p";
        boot.initrd.availableKernelModules = [
          "vmd"
          "xhci_pci"
          "ahci"
          "nvme"
          "sd_mod"
        ];
        boot.loader = {
          systemd-boot.enable = true;
          efi.canTouchEfiVariables = true;
        };
        programs.git.enable = true;
      }
    ];
  };
}
