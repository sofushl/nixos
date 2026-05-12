{ userconf, ... }:

{
  imports = [
    ./hardware.nix

    ../presets/niri-desktop.nix

    # ../../modules/impermanence.nix

    # inputs.impermanence.nixosModules.impermanence
  ];
  networking.hostName = "Acer";
}
