{ self, ... }:
{
  flake.nixosModules.init = { userconf, ... }: {

    system.stateVersion = "26.11";

    imports = with self.nixosModules; [ disko ];

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
  };
}
