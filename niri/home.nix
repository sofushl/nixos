{
  config,
  pkgs,
  home-manager,
  ...
}:

{
  gtk = {
    enable = true;

    theme.name = "Adwaita-dark";

    gtk3 = {
      extraConfig.gtk-application-prefer-dark-theme = 1;
      theme.name = "Adwaita-dark";
    };
    gtk4 = {
      colorScheme = "dark";
      theme.name = "Adwaita-dark";
    };
  };

  dconf.settings = {
    "org/gnome/desktop/interface" = {
      color-scheme = "prefer-dark";
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
      extraPortals = [ pkgs.xdg-desktop-portal-wlr ];
    };
  };
}
