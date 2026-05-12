{ userconf, pkgs, ... }:

{

  # Networking
  networking.networkmanager.enable = true;

  programs = {
    # For captive network connection
    captive-browser = {
      enable = true;
      interface = userconf.wifiboard;
    };
  };

  # Bootloader
  boot.loader = {
    systemd-boot.enable = true; # false on WSL
    efi.canTouchEfiVariables = true;
  };

  hardware = {
    bluetooth.enable = true;
    graphics.enable = true;
  };

  services = {
    # Enable sound with pipewire.
    pulseaudio.enable = false;
    pipewire = {
      enable = true;
      alsa.enable = true;
      alsa.support32Bit = true;
      pulse.enable = true;
      jack.enable = true;
    };

    # Enable CUPS to print documents.
    printing.enable = true;

    # Thermal security
    thermald.enable = true;

  };

  environment.systemPackages = with pkgs; [
    # User applications
    nextcloud-client
    onlyoffice-desktopeditors
    vesktop
    spotify
    scenebuilder
    loupe
  ];
}
