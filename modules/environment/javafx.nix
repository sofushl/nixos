{ self, inputs, ... }:

{
  flake.nixosModules.javafxDev =
    { lib, pkgs, ... }:
    let
      jdkWithFX = pkgs.openjdk.override { enableJavaFX = true; };
      libs = with pkgs; [
        javaPackages.openjfx25
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
          jdkWithFX
          pkgs.javaPackages.compiler.openjdk25
          pkgs.maven
        ]
        ++ libs;

        variables = {
          JAVA_HOME = "${pkgs.javaPackages.compiler.openjdk25}";
        };
      };
      services.pipewire.jack.enable = lib.mkForce false;

      programs.nix-ld.enable = true;
      programs.nix-ld.libraries = libs;
    };
}
