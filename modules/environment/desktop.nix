{ self, inputs, ... }:

{
  flake.nixosModules.desktop =
    {
      userconf,
      pkgs,
      lib,
      ...
    }:

    {
      programs = {
        # For captive network connection
        captive-browser = {
          enable = true;
          interface = userconf.wifiboard;
        };
      };

      # Enable networking
      networking.networkmanager.enable = lib.mkDefault true;

      services = {

      };

      systemd.user.services.mount-symlink = {
        script = ''
          ln -sfn \
          /run/media/${userconf.username} \
          /home/${userconf.username}/media
        '';

        serviceConfig.Type = "oneshot";

        wantedBy = [ "default.target" ];
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

        # User applications
        onlyoffice-desktopeditors
        vesktop
        spotify
        scenebuilder
        loupe

        #USB disk management
        usbutils
        udiskie

      ];

      home-manager.users.${userconf.username}.services.udiskie = {
        enable = true;
        automount = true;
        notify = false;
      };

    };
}
