{
  flake.nixosModules.desktop =
    {
      userconf,
      pkgs,
      lib,
      ...
    }:

    {

      # Enable networking
      networking.networkmanager.enable = lib.mkDefault true;

      programs = {
        # For captive network connection
        captive-browser = {
          enable = true;
          interface = userconf.wifiboard;
        };
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

        # USB management
        udisks2.enable = true;
        gvfs.enable = true;

        # Thermal security
        thermald.enable = true;
      };

      environment.systemPackages = with pkgs; [

        #USB disk management
        usbutils
        udiskie

      ];

      home-manager.users.${userconf.username}.services.udiskie = {
        enable = true;
        automount = true;
        settings = {
          program_options = {
            udisks_version = 2;
          };
          icon_names.media = [ "media-optical" ];
        };

      };

      boot.loader = {
        systemd-boot.enable = true;
        systemd-boot.configurationLimit = 10;
        efi.canTouchEfiVariables = true;
      };
    };
}
