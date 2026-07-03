{
  flake.nixosModules.javafxDev =
    { lib, pkgs, ... }:
    let
      jdkWithFX = pkgs.openjdk.override { enableJavaFX = true; };
      libs = with pkgs; [
        openjfx
        mesa
        gtk3
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
        systemPackages = [
          #jdkWithFX
          pkgs.javaPackages.compiler.openjdk25
          pkgs.maven
        ]
        ++ libs;

        variables.JAVA_HOME = "${pkgs.javaPackages.compiler.openjdk25}";

        sessionVariables.LD_LIBRARY_PATH = lib.makeLibraryPath libs;
      };
      services.pipewire.jack.enable = lib.mkForce false;

      programs.nix-ld.enable = true;
      programs.nix-ld.libraries = libs;
    };
}
