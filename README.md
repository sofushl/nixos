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
  freednsupdate = "yourUpdateLink"; # for freedns dynamic ip updater cron job
}
```

## Dotfiles

All non nix files used for the config is in ```./dotfiles/```.


## Install (without disko)

Using a simple nixos configuration you can make a ultra bare bones nix config with the sole purpose of rebuilding into a different system. This is an old and weird way to go about doing things in nix, which is why I moved it into the bottom of my README file.

| configuration.nix | shell commands (example) |
|---|---|
| <pre>{<br>  imports = [<br>    ./hardware-configuration.nix<br>  ];<br>  <br>  boot.loader.systemd-boot.enable = true;<br>  boot.loader.efi.canTouchEfiVariables = true;<br>  <br>  networking.networkmanager.enable = true;<br>  console.keyMap = "no";<br>  <br>  users.users.root.initialPassword = "p";<br>  <br>  users.users.sofushl = {<br>    isNormalUser = true;<br>    extraGroups = [ "wheel" "networkmanager" ];<br>    initialPassword = "p";<br>  };<br>  <br>  programs.neovim = {<br>    enable = true;<br>    defaultEditor = true;<br>    viAlias = true;<br>    vimAlias = true;<br>  };<br>  <br>  programs.git.enable = true;<br>  programs.nix-ld.enable = true;<br>  <br>  system.stateVersion = "25.11";<br>}</pre> | <pre>sudo loadkeys no<br>nmtui<br><br>sudo mkfs.fat -F 32 -n BOOT /dev/nvme0n1p1<br>sudo mkfs.xfs /dev/nvme0n1p4 -L ROOT<br><br>sudo mount /dev/disk/by-label/ROOT /mnt<br>sudo mkdir -p /mnt/boot<br>sudo mount /dev/disk/by-label/BOOT /mnt/boot<br>sudo nixos-generate-config --root /mnt<br><br>sudo git clone https://github.com/sofuslind/nixos.git<br>sudo rm /mnt/etc/nixos/configuration.nix<br>sudo mv /nixos/initconf.nix /mnt/etc/nixos/configuration.nix<br><br>cd /mnt<br>sudo nixos-install</pre> |
