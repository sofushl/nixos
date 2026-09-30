{
  flake.homeModules.javaWithFx =
    { lib, pkgs, ... }:

    # RECCOMENDED PRESERVATION OF "$HOME/.m2" "$HOME/.local/share/JetBrains" "$HOME/.config/JetBrains"

    let
      jdkWithFX = pkgs.openjdk.override { enableJavaFX = true; };

      schemaPkgs = with pkgs; [
        gtk3
        gsettings-desktop-schemas
      ];
    in
    {
      programs.java = {
        package = jdkWithFX;
        enable = true;
      };

      home.sessionVariables.GSETTINGS_SCHEMA_DIR = (
        lib.concatStringsSep ":" (map pkgs.glib.getSchemaPath schemaPkgs)
      );

      home.packages = with pkgs; [
        scenebuilder
        jetbrains.idea

        maven
        gsettings-desktop-schemas

        # libs
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
    };
}
