# NixOS Dendritic Config

Dendritic flake-parts + import tree based config, should be cleaner and more managable than [my old config](https://github.com/sofuslind/nixos-old).

## Modules

base.nix is universal configuration across all hosts.

user.nix sets up userspace for one user selected in the active host module.

desktop.nix is basic setup for hosts that gets used with graphical interface.

server.nix is a WIP server config for my home server.

#### hosts
Host machine configurations, including WSL config and presets for server and niri desktop setups.

#### programs
Home manager and nixos based program configuration modules, including my neovim config.

#### services
Services for various purposes, including nextcloud config.

#### system
Miscellaneous larger files that configure session and environment, including my niri config and development library setup for javafx and iced-rs

## Library

This system is meant for one single user and user configuration relies on ```./lib/sofushl.nix```

userconf includes several parts from ```./lib``` defined in```.modules/hosts/*``` and a secret part:

Make ```/etc/nixos/secrets.nix``` like this:

``` nix
{
  email = "youremail@example.com"; # Email for automated mails and login
  password = "yourpassword"; # High security online logins
  pin = "yourpin"; # Root and user login on this device
}
```

## Dotfiles

All non nix files used for the config is in ```./dotfiles/```.

