{
  flake.nixosModules.javaWithFx =
    { lib, pkgs, ... }:

    # RECCOMENDED PRESERVATION OF "$HOME/.m2" "$HOME/.local/share/JetBrains" "$HOME/.config/JetBrains" "$HOME/.vscode"

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
        scenebuilder
        jetbrains.idea
        vscode

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
