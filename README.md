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

## Configuration

Boilerplate for nixosModules:

```nix
{
  self,
  inputs,
  ...
}:

{
  flake.nixosModules.MODULENAME = 
    {userconf, pkgs, ...}:
    {
      # Your config here

      home-manager.users.${userconf.username} = {
        # Your homemanager config here
      };
  };
}
```

## Library

This system is meant for one single user and user configuration relies on ```./lib/sofushl.nix```

userconf includes several parts from ```./lib``` defined in```.modules/hosts/*``` and a secret part:

Make ```/etc/nixos/secrets.nix``` like this:

``` nix
{
  email = "youremail@example.com"; # Email for automated mails and login
  password = "yourpassword"; # High security online logins
  pin = "yourpin"; # Root and user login on this device
  dnsUpdateLinks = [
    "yourUpdateLink1"
  ]; # for freedns dynamic ip updater cron job
}
```

## Dotfiles

All non nix files used for the config is in ```./dotfiles/```.


## Dual boot installation

Using a simple nixos configuration you can make a ultra bare bones nix config with the sole purpose of rebuilding into a different system. This is an old and weird way to go about doing things in nix, which is why I moved it into the bottom of my README file. This example of shell commands is intended for when you have windows installed (without recovery partition) and already have established an xfs linux partition on the 4th partition. The example is quite niche but I'm replacing it with disko anyway...


### `Shell commands (example)`

```bash
# Keyboard layout
sudo loadkeys no

# Network setup
nmtui

# Format partition (replace with your designated linux partition)
# Note that this needs to be set up beforehand with parted or similar.
sudo mkfs.xfs /dev/nvme0n1p4 -L ROOT

# Mount
sudo mount /dev/disk/by-label/ROOT /mnt
sudo mkdir -p /mnt/boot
sudo mount /dev/disk/by-label/BOOT /mnt/boot
sudo nixos-generate-config --root /mnt

# Apply config
sudo git clone https://github.com/sofuslind/nixos.git
sudo rm /mnt/etc/nixos/configuration.nix
cat /nixos/README.md

# get the configuration into /mnt/etc/configuration.nix
sudo vi /mnt/etc/nixos/configuration.nix

# Install
cd /mnt
sudo nixos-install
```

### `configuration.nix`

```nix
{
  imports = [ ./hardware-configuration.nix ];

  boot.loader.systemd-boot.enable = true;
  boot.loader.efi.canTouchEfiVariables = true;

  networking.networkmanager.enable = true;
  console.keyMap = "no";

  users.users.root.initialPassword = "p";

  users.users.sofushl = {
    isNormalUser = true;
    initialPassword = "p";
    extraGroups = [
      "wheel"
      "networkmanager"
    ];
  };

  nix.settings.experimental-features = [
    "nix-command"
    "flakes"
  ];

  programs.neovim = {
    enable = true;
    defaultEditor = true;
    viAlias = true;
    vimAlias = true;
  };

  programs.git.enable = true;
  programs.nix-ld.enable = true;

  system.stateVersion = "25.11";
}

```
