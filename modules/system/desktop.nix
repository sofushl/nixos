{ self, ... }: {
  flake.nixosModules.desktop =
    {
      userconf,
      pkgs,
      lib,
      ...
    }:

    {
      networking.networkmanager.enable = lib.mkDefault true;

      programs = {
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

        thermald.enable = true;
      };

      home-manager.users.${userconf.username}.imports = [ self.homeModules.desktop ];
    };

  flake.homeModules.desktop = { pkgs, ... }: {
    xdg = {
      enable = true;
      userDirs = {
        enable = true;
        createDirectories = false;
      };
    };

    home.packages = with pkgs; [
      spotify
      discord
      prismlauncher
      element-desktop
      onlyoffice-desktopeditors
    ];

    services.udiskie = {
      enable = true;
      automount = true;
      settings = {
        program_options = {
          udisks_version = 2;
        };
        icon_names.media = [ "media-optical" ];
      };
    };
  };
}
