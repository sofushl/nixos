{ self, inputs, ... }:
let
  userconf = import ../../../lib/sofushl.nix;
  sysconf = import ../../../lib/PLACEHOLDER.nix;
  sshkeys = import ../../../lib/sshkeys.nix;
  secrets = import /etc/nixos/secrets.nix;
in
{
  flake.nixosConfigurations.Init = inputs.nixpkgs.lib.nixosSystem {
    system = "x86_64-linux";

    specialArgs = {
      inherit inputs;
      userconf = userconf // sysconf // sshkeys // secrets;
    };

    modules = with self.nixosModules; [
      PLACEHOLDERHardware
      disko
      preservation

      base
      user
      git
      networkmanager

      {
        boot.loader = {
          systemd-boot.enable = true;
          systemd-boot.configurationLimit = 10;
          efi.canTouchEfiVariables = true;
        };

        system.stateVersion = userconf.state;

        powerManagement.cpuFreqGovernor = "powersave";
      }
    ];
  };
}
