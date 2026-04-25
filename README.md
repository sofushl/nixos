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

### dev.nix
Contains developer tools and dependencies for neovim.
Enables graphical applications based on javafx or iced-rs, but now it just applies the same things to the global path. 

### neovim.nix
Home-manager based configuration of neovim intened for javascript and more.

## Niri

### niri.nix
Niri config, made in a minimalistic look with pastel red and dark color scheme

### librewolf.nix
Attemt to rice librewolf, very much not working at the moment.

### /config
Other file types than .nix files used to configure niri itself as well as waybar, alacritty, fuzzel and more...

## Other
nixos config is made in a ~/Documents/nixos directory, .gitignore includes any files that can disturb the repo. 

### vscodium
settings.json for vim in vscodium and vsix files that doesnt exist in the open source repo that vscodium uses.

### cosmic.nix
Excessively debloated COSMIC DE from System76, WIP to move it to home-manager based config. (not in use) 

### plasma.nix
Just another plasma setup. (not in use)

### LICENCE

MIT License - Copyright (c) 2026 Sofus Højberg Lind