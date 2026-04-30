# This is an example file, should reside in /etc/nixos/variables.nix"

{
  username = "sofushl";
  displayname = "Sofus Lind"; # Display name on pc and git commits
  email = "43791049+sofuslind@users.noreply.github.com"; # For easy git config
  hostname = "nixos";
  wifiboard = "wlp0s20f3";
  swap = 8; # Sets swapfile in /var/lib/swapfile to 8 GB
  state = "26.05";
  niri = true; # Enables niri config
  devenv = true; # Enables development tools including neovim config
  wsl = false; # Enables WSL dependencies
  omarchy = false; # Enables https://github.com/henrysipp/omarchy-nix/ !NOT AVALIABLE!
  cosmic = false; # Enables COSMIC DE from system 76
  plasma = false; # Enables KDE Plasma
  server = false; # Enables server configuration server.nix
  defaultpassword = "p"; # Temporary / remember to replace
  sshkeys = [ ]; # String list of public ssh keys
  domains = [ ]; # String list of trusted domains
  macaddress = "12:something:a1:b1:something";
  host = "iplinkorwhatever";
}
