{ self, ... }: {
  flake.homeModules.niriMin = { pkgs, ... }: {
    imports = with self.homeModules; [
      base
      environment
      user
      desktop
      niri
      mimeapps

      kitty
      browser
      neovim
      yazi
      git
      claude

      bash
      fonts
      fastfetch

      {
        home.packages = with pkgs; [
          spotify
          discord
          element-desktop
          onlyoffice-desktopeditors
          vlc
          loupe
        ];
      }
    ];
  };
}
