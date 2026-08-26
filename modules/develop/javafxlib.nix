{
  flake.nixosModules.javafxlib =
    { lib, pkgs, ... }:
    let
      libs = with pkgs; [
        javaPackages.compiler.openjdk
        openjfx
        maven
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
        pipewire
      ];
    in
    {
      environment = {
        systemPackages = libs ++ [ pkgs.gsettings-desktop-schemas ];

        variables = {
          JAVA_HOME = "${pkgs.javaPackages.compiler.openjdk}";
          LD_LIBRARY_PATH = lib.makeLibraryPath libs;
          GSETTINGS_SCHEMA_DIR = map pkgs.glib.getSchemaPath libs;
        };
      };
      services.pipewire.jack.enable = lib.mkForce false;

      programs.nix-ld.enable = true;
      programs.nix-ld.libraries = libs;
    };
}
