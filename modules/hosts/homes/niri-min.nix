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

      bash
      fonts
      fastfetch

      claude

      {
        home.packages = with pkgs; [
          spotify
          discord
          element-desktop
          onlyoffice-desktopeditors
        ];
      }
    ];
  };
}
