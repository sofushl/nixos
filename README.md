# NixOS config description

Multi file setup that allows for easy experimentation across multiple devices.

### flake.nix
Installer file, enables home-manager, see comments in main.nix

### main.nix
Main file duh...

### packages.nix
Packages for development on nixos.

### variables.nix
Used to define device / user specific values, imported from /etc/nixos/variables.nix into flake.nix

## Niri

### niri.nix
Niri config, made in a minimalistic look with pastel red and dark color scheme

### librewolf.nix
Attemt to rice librewolf, very much not working at the moment.

### /config
Other file types than .nix files used to configure niri itself as well as waybar, alacritty, fuzzel and more...

## Development

### vscodium
Nix files that configure my vscodium and intellij idea with shellscripts for coding on nixos, /vsix includes vsix files that doesnt exist in the open source repo that vscodium uses.

### neovim.nix
Home-manager based configuration of neovim intened for javascript and more.

### shell.nix
Nix shell that enables graphical applications based on javafx or iced-rs.

## Desktop Environments

### cosmic.nix
Excessively debloated COSMIC DE from System76.

### plasma.nix
Just another plasma setup. (not in use)

## Other information
Nixos config is made in a ~/Documents/nixos directory, .gitignore includes any files that can disturb the repo. 
