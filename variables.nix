# This is an example file, should reside in /etc/nixos/variables.nix"

{
  username = "sofushl";
  displayname = "Sofus Lind"; # Display name on pc and git commits
  email = "43791049+sofuslind@users.noreply.github.com"; # For easy git config
  hostname = "nixos";
  wifiboard = "wlp0s20f3";
  swapSize = 8;
  swapDevice = "/.swapfile";
  state = "26.05";
  niri = true; # Enables niri config
  devenv = true; # Enables dev.nix and neovim config
  wsl = false; # Enables WSL dependencies
  omarchy = false; # Enables https://github.com/henrysipp/omarchy-nix/
  server = false;
}
