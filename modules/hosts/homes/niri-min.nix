{ self, ... }: {
  flake.homeModules.niriMin = { pkgs, ... }: {
    imports = with self.homeModules; [
      base
      environment
      user
      desktop
      niri
      mimeapps
      vesktop

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
          element-desktop
          vlc
          loupe
        ];
      }
    ];
  };
}
