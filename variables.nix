# This is an example file, should reside in /etc/nixos/variables.nix"

{
  username = "username";
  fullname = "Display Name";
  hostname = "Computer";
  wifiboard = "wlp0s20f3";
  swapSize = 8;
  swapDevice = "/.swapfile";
  state = "26.05";
  niri = true; # Enables niri config
  devenv = true; # Enables antishell.nix
  wsl = false; # Enables WSL dependencies
}
