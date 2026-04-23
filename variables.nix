# This is an example file, should reside in /etc/nixos/variables.nix"

{
  username = "username";
  fullname = "Display Name";
  hostname = "Computer";
  wifiboard = "wlp0s20f3";
  bootd = true;
  swapSize = 8;
  swapDevice = "/.swapfile";
  state = "26.05";
  imports = [
    /home/username/Documents/nixos/packages.nix
    /home/username/Documents/nixos/niri/niri.nix
    /home/username/Documents/nixos/development/antishell.nix
    /home/username/Documents/nixos/development/vscodium/vscodium.nix
    ];
}