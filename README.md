# NixOS config description

Multi file setup that allows for easy experimentation across multiple devices.

### main.nix
Main file duh...

### packages.nix
Packages for java programming with vscodium.

### user.nix
See user_example.nix, used to define imports, useraccount and hostname. Makes import in configuration.nix easy.

## Niri

### niri.nix
Niri config, made in a minimalistic look with pastel red and dark color scheme

### librewolf.nix
Attemt to rice librewolf, very much not working at the moment.

### /config
Other file types than .nix files used to configure niri itself as well as waybar, alacritty, fuzzel and more...

## Applications

### vscodium
Nix files that cofigure my vscodium with shellscripts and a java shell for development on nixos, /vsix includes vsix files that doesnt exist in the open source repo that vscodium uses.

### nvim
WIP

## Desktop Environments

### cosmic.nix
Excessively debloated COSMIC DE from System76.

### plasma.nix
Just another plasma setup. (not in use)

## Other information

Command for allowing git and other file changes to work without root in the /etc/nixos directory/
sudo setfacl -R -m u:{YOUR_USERNAME}:rwx /etc/nixos/

Nixos config is made in a ~/Documents/nixos directory, .gitignore includes user.nix 
