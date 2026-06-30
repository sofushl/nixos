# NixOS Dendritic Config

Dendritic flake-parts + import tree based config, should be cleaner and more managable than [my old config](https://github.com/sofushl/nixos-old).

## Modules

[base.nix](./modules/base.nix) is universal configuration across all hosts, sets up essential and QoL system configuration such as enabling nvim, git and ssh.

[user.nix](./modules/user.nix) sets up userspace and home-manager for one user selected in the active host module. (Also essential and universal across all hosts)

[options.nix](./modules/options.nix) enables the config to include multiple homeModules. 

#### [environment](./modules/environment/README.md)
Essential configuration of system, session and environment.

#### [hosts](./modules/hosts/README.md)
Host machine configurations, including special configs and presets for desktop setups.

#### [programs](./modules/programs/README.md)
Home manager based program configuration.

#### [services](./modules/services/README.md)
Services and programs configured with nixosModules for various purposes.


### Configuration

Boilerplate for nixosModules and/or homeModules:

```nix
{ self, inputs, ... }:

{
  flake.nixosModules.MODULENAME = 
    {userconf, pkgs, ...}:
    {
      # Your config here

      home-manager.users.${userconf.username}.imports = [ self.homeModules.HOMEMODULE ];
    };
  
  flake.homeModules.HOMEMODULE = 
    {userconf, pkgs, ...}:
    {
      # Your homemanager config heredd
    };
    
}
```

## Library

This system is meant for one single user and user configuration relies on ```./lib/sofushl.nix```

userconf includes several parts from ```./lib``` defined in```.modules/hosts/*``` and a secret part (Working on removing this):

Make ```/etc/nixos/secrets.nix``` like this:

``` nix
{
 # For Desktop
 edupass = "your eduroam network password";
  networks = {
    "ssid1" = "password1";
  }; # for declarative wifi management
  

  # For Server
  dnsUpdateLinks = [
    "yourUpdateLink1"
  ]; # for freedns dynamic ip updater cron job

  secretPages = [
        {
          name = "secretpage";
          root = "/dist";
          repo = "github link for the secret domain";
          domain = "yoursecretdomain";
        }
  ]; # Used in git-sites service
}
```

## Dotfiles

All non nix files used for the config is in ```./dotfiles/```.

## Disko installation

```bash
sudo loadkeys no

nmtui

sudo git clone https://github.com/sofushl/nixos.git

# If you didn't make the config beforehand, make it now:
sudo mkdir nixos/modules/hosts/YOUR_HOST
cd nixos/modules/hosts/YOUR_HOST

sudo nixos-generate-config --no-filesystems --dir .

# Otherwise, just generate hardware configuration:

sudo mkdir hardware-tmp
sudo nixos-generate-config --no-filesystems --dir ./hardware-tmp

sudo mv ./hardware-tmp/hardware-configuration.nix ./hardware.nix

# Lastly make secrets.nix run and run the installer

sudo vi /etc/nixos/secrets.nix # You will have to remake this when in the system

cd /nixos

# Remember to update ./lib/YOUR_HOST.nix before and after installing

sudo nix --extra-experimental-features "nix-command flakes" \
  run 'github:nix-community/disko/latest#disko-install' -- \
  --flake .#init \
  --disk main /dev/YOUR_DISK \

# After rebooting:

ssh-keygen
cat .ssh/id_ed25519.pub 

# Add to github and clone the repo

git clone git@github.com:sofushl/nixos.git # My link

# Update ./lib/YOUR_HOST.nix and ./lib/sshkeys.nix and 

# Rebuild with correct hostname make sure you did everything right

```

## Home-manager installation

```bash

# Wezterm
curl -fsSL https://apt.fury.io/wez/gpg.key | sudo gpg --yes --dearmor -o /usr/share/keyrings/wezterm-fury.gpg
echo 'deb [signed-by=/usr/share/keyrings/wezterm-fury.gpg] https://apt.fury.io/wez/ * *' | sudo tee /etc/apt/sources.list.d/wezterm.list
sudo chmod 644 /usr/share/keyrings/wezterm-fury.gpg

# Niri
sudo add-apt-repository ppa:avengemedia/danklinux

sudo apt update && sudo apt upgrade 
sudo apt install wezterm-nightly niri

# Nix
curl --proto '=https' --tlsv1.2 -L https://nixos.org/nix/install | sh -s -- --daemon

sudo /etc/nix/nix.conf
# Write "experimental-features = nix-command flakes"

git clone https://github.com/sofushl/nixos.git
cd nixos
nix run nixpkgs#home-manager -- switch --flake .#CONFIGNAME --impure -b back

# Purge snap (after new browser and terminal is installed)
sudo systemctl stop snapd
sudo snap list | awk '{print $1}' | tail -n +2 | xargs -I{} sudo snap remove {}
sudo apt purge snapd -y
rm -rf ~/.snap ~/snap
sudo rm -rf /var/cache/snapd /var/lib/snapd

sudo apt autoremove --purge -y
sudo apt autoclean

# Now you can rebuild anytime with:
home-switch
```

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
sudo git clone https://github.com/sofushl/nixos.git
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

  system.stateVersion = "26.11";
}

```
