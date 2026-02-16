{ config, pkgs, ... }:

{
  imports =
    [
      ./hardware-configuration.nix
    ];

# Bootloader.
boot.loader.systemd-boot.enable = true;
boot.loader.efi.canTouchEfiVariables = true;

boot.kernelPackages = pkgs.linuxPackages_latest;

networking.hostName = "nixos";

# Configure network proxy if necessary
# networking.proxy.default = "http://user:password@proxy:port/";
# networking.proxy.noProxy = "127.0.0.1,localhost,internal.domain";

# Enable networking
networking.networkmanager.enable = true;

# Set your time zone.
time.timeZone = "Europe/Oslo";

# Select internationalisation properties.
i18n.defaultLocale = "en_GB.UTF-8";

i18n.extraLocaleSettings = {
    LC_ADDRESS = "nb_NO.UTF-8";
    LC_IDENTIFICATION = "nb_NO.UTF-8";
    LC_MEASUREMENT = "nb_NO.UTF-8";
    LC_MONETARY = "nb_NO.UTF-8";
    LC_NAME = "nb_NO.UTF-8";
    LC_NUMERIC = "nb_NO.UTF-8";
    LC_PAPER = "nb_NO.UTF-8";
    LC_TELEPHONE = "nb_NO.UTF-8";
    LC_TIME = "nb_NO.UTF-8";
};

# Plasma setup
services.desktopManager.plasma6.enable = true;
services.displayManager.sddm = {
  enable = true;
  wayland.enable = true;
};

# Remove "KDE Bloat"
environment.plasma6.excludePackages = with pkgs.kdePackages; [
	discover
	elisa
	kwrited
	kate
	gwenview
	okular
	khelpcenter
	kinfocenter	
];


# Keyboard config
console.keyMap = "no";
services.xserver.xkb = {
  layout = "no";
  variant = "windows,";
};


# Enable CUPS to print documents.
services.printing.enable = true;

# Enable bluetooth
hardware.bluetooth.enable = true;

# Enable sound with pipewire.
services.pulseaudio.enable = false;
security.rtkit.enable = true;
services.pipewire = {
    enable = true;
    alsa.enable = true;
    alsa.support32Bit = true;
    pulse.enable = true;
    jack.enable = true;

    # use the example session manager (no others are packaged yet so this is enabled by default,
    # no need to redefine it in your config for now)
    #media-session.enable = true;
};


# User account.
users.users.sofushl = {
    isNormalUser = true;
    description = "Sofus Højberg Lind";
    extraGroups = [ "networkmanager" "wheel" ];
};

# Allow unfree packages
nixpkgs.config.allowUnfree = true;

# List packages installed in system profile. To search, run:
# $ nix search wget
environment.systemPackages = with pkgs; [
	librewolf
	vscodium	
	element-desktop
	openssh
	javaPackages.compiler.openjdk25
	geteduroam
  discordo
	git
  libreoffice-fresh
];

# Nix stuff?
nix.settings = {
	experimental-features = ["nix-command" "flakes"];
};

# Some programs need SUID wrappers, can be configured further or are
# started in user sessions.
# programs.mtr.enable = true;
# programs.gnupg.agent = {
#   enable = true;
#   enableSSHSupport = true;
# };

# List services that you want to enable:

# Enable the OpenSSH daemon.
# services.openssh.enable = true;

# Open ports in the firewall.
# networking.firewall.allowedTCPPorts = [ ... ];
# networking.firewall.allowedUDPPorts = [ ... ];
# Or disable the firewall altogether.
# networking.firewall.enable = false;

# This value determines the NixOS release from which the default
# settings for stateful data, like file locations and database versions
# on your system were taken. It‘s perfectly fine and recommended to leave
# this value at the release version of the first install of this system.
# Before changing this value read the documentation for this option
# (e.g. man configuration.nix or on https://nixos.org/nixos/options.html).
system.stateVersion = "25.11"; # Did you read the comment?

}
