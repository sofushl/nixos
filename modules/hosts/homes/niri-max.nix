{ self, ... }: {
  flake.homeModules.niriMax = { pkgs, ... }: {
    imports = with self.homeModules; [
      niriMin

      obsidian
      vscodium

      rclone

      node
      javaWithFx
    ];

    home.packages = with pkgs; [
      libreoffice

      cursor-cli
      code-cursor

      wl-clicker
      postman
      geogebra6
      krita
      inkscape
    ];
  };
}
