{ self, ... }: {
  flake.homeModules.niriMax = { pkgs, ... }: {
    imports = with self.homeModules; [
      base
      environment
      user
      desktop
      niri
      mimeapps

      kitty
      browser
      obsidian
      vscodium
      neovim
      yazi
      git
      claude

      bash
      fonts
      rclone
      fastfetch

      node
      javaWithFx
    ];

    home.packages = with pkgs; [
      spotify
      discord
      element-desktop
      libreoffice
      vlc
      loupe

      cursor-cli
      code-cursor

      wl-clicker
      docker
      watchmate
      siglo
      postman
      geogebra6
      krita
      inkscape
      thonny
    ];
  };
}
