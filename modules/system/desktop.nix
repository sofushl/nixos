{ self, ... }: {
  flake.nixosModules.desktop =
    {
      userconf,
      pkgs,
      lib,
      ...
    }:

    {
      networking.networkmanager.enable = true;

      programs = {
        captive-browser = {
          enable = true;
          interface = userconf.wifiboard;
        };
      };

      hardware.graphics.enable = true;

      services = {
        logind.settings.Login = {
          HandlePowerKey = "ignore";
          HandlePowerKeyLongPress = "poweroff";
        };

        pipewire = {
          enable = true;
          alsa.enable = true;
          alsa.support32Bit = true;
          pulse.enable = true;
          jack.enable = true;
        };

        thermald.enable = true;
        udisks2.enable = true;
      };

      security.rtkit.enable = true;

      home-manager.users.${userconf.username}.imports = with self.homeModules; [
        desktop
        kitty
      ];
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
      element-desktop
      onlyoffice-desktopeditors
      thonny
      ripes
      postman
      geogebra6
      krita
      inkscape
      teams-for-linux
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

    systemd.user.services.polkit-gnome-authentication-agent-1 = {
      Unit = {
        Description = "polkit-gnome-authentication-agent-1";
        Wants = [ "graphical-session.target" ];
        After = [ "graphical-session.target" ];
      };
      Install = {
        WantedBy = [ "graphical-session.target" ];
      };
      Service = {
        Type = "simple";
        ExecStart = "${pkgs.polkit_gnome}/libexec/polkit-gnome-authentication-agent-1";
        Restart = "on-failure";
        RestartSec = 1;
        TimeoutStopSec = 10;
      };
    };
  };
}
