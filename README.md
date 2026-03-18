# NixOS config description

Multi file setup that allows for easy experimentation across multiple devices.

### main.nix
Main file duh...

### cosmic.nix
Excessively debloated COSMIC DE from System76.

### packages.nix
Packages for java programming with vscodium.

### plasma.nix
Just another plasma setup. (not in use)

## /dotfiles
Configuration that is mostly if not only stylistic:

### alacritty.nix
Alacritty terminal emulator installation with .toml configuration imported to make it a pastel red and dark color sceme.

### niri.nix
WIP niri config, made in a minimalistic look with pastel red and dark color scheme

## Other information

python.sh requires uv, but sets up a nix shell and syncs uv with a pyproject.toml

Command for allowing git and other file changes to work without root in the /etc/nixos directory/
sudo setfacl -R -m u:{YOUR_USERNAME}:rwx /etc/nixos/

Nixos config is made in a ~/Documents/nixos, .gitignore includes user.nix which is the file used to import the .nix files I want to be active at a given moment