{ self, ... }:

{
  flake.nixosModules.initPreset =
    { userconf, ... }:

    {
      imports = with self.nixosModules; [
        base
        user
        disko
        preservation
	networkmanager
      ];
	
	boot.loader ={
	systemd-boot.enable = true;
	efi.canTouchEfiVariables = true;
	};

    };
}
