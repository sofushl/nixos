{
  config,
  pkgs,
  home-manager,
  ...
}:

{
  gtk = {
    enable = true;
    colorScheme = "dark";

    theme.name = "Adwaita-dark";

    gtk4 = {
      colorScheme = "dark";
      theme.name = "Adawaita-dark";
    };
  };

  xdg.configFile."sunsetr/sunsetr.toml" = {
    source = ./config/sunsetr.toml;
    force = true;
  };
}
