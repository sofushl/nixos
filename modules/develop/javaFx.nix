{
  # RECCOMENDED PRESERVATION OF "$HOME/.m2" "$HOME/.local/share/JetBrains" "$HOME/.config/JetBrains"

  flake.nixosModules.javaFx =
    { lib, pkgs, ... }:
    let
      jdkWithFx = pkgs.openjdk.override { enableJavaFX = true; };

      libs = with pkgs; [
        mesa
        gtk3
        gsettings-desktop-schemas
        glib
        libGL
        libglvnd
        libpulseaudio
        libva
        libx11
        libxtst
        libxrender
        libxext
        libxi
        libxcursor
        libxrandr
        libxxf86vm
        libxfixes
        libxinerama
      ];

      schemaPkgs = with pkgs; [
        gtk3
        gsettings-desktop-schemas
      ];
    in
    {

      programs = {
        java = {
          enable = true;
          package = jdkWithFx;
          binfmt = true;
        };

        nix-ld = {
          enable = true;
          libraries = libs;
        };
      };

      environment = {
        systemPackages =
          with pkgs;
          [
            scenebuilder
            jetbrains.idea
            maven
          ]
          ++ libs
          ++ schemaPkgs;

        variables = {
          JAVA_HOME = "${jdkWithFx}";
          GSETTINGS_SCHEMA_DIR = (lib.concatStringsSep ":" (map pkgs.glib.getSchemaPath schemaPkgs));
        };
      };
    };
}
