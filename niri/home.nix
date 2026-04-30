{
  pkgs,
  ...
}:

{

  imports = [ ./librewolf.nix ];

  gtk = {
    enable = true;
    colorScheme = "dark";

    gtk3 = {
      enable = true;
      extraConfig.gtk-application-prefer-dark-theme = true;
      colorScheme = "dark";
    };

    gtk4 = {
      enable = true;
      extraConfig.gtk-application-prefer-dark-theme = true;
      colorScheme = "dark";
    };
  };

  dconf.settings = {
    "org/gnome/desktop/interface" = {
      color-scheme = "prefer-dark";
    };
  };

  home.file = {
    ".config/cosmic" = {
      force = true;
      recursive = true;
      source = ./config/cosmic;
    };
  };

  xdg = {
    enable = true;

    configFile."sunsetr/sunsetr.toml" = {
      source = ./config/sunsetr.toml;
      force = true;
    };

    portal = {
      enable = true;
      extraPortals = [
        pkgs.xdg-desktop-portal-gtk
        pkgs.xdg-desktop-portal-wlr
      ];
      config.common.default = [ "gtk" ];
    };
  };
}
