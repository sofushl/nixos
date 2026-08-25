{
  flake.nixosModules.javaWithFx =
    { lib, pkgs, ... }:
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

      environment.variables.GSETTINGS_SCHEMA_DIR = lib.mkDefault (map pkgs.glib.getSchemaPath schemaPkgs);

      environment.systemPackages = with pkgs; [
        maven
        gsettings-desktop-schemas
        scenebuilder
        jetbrains.idea
        eclipses.eclipse-java

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
