let
  pkgs = import <nixpkgs> { };

  javafxDeps = with pkgs; [
    pkgs.gtk3
    pkgs.glib
    pkgs.libGL
    pkgs.libglvnd
    pkgs.libpulseaudio
    pkgs.libva
    pkgs.xorg.libX11
    pkgs.xorg.libXtst
    pkgs.xorg.libXrender
    pkgs.xorg.libXext
    pkgs.xorg.libXi
    pkgs.xorg.libXcursor
    pkgs.xorg.libXrandr
    pkgs.xorg.libXxf86vm
    pkgs.xorg.libXfixes
    pkgs.xorg.libXinerama
    pkgs.javaPackages.openjfx25
    pkgs.maven
    pkgs.nodejs_24
  ];

in
pkgs.mkShell {
  packages = [ pkgs.jdk25 ] ++ javafxDeps;

  shellHook = ''
    export JAVA_HOME=${pkgs.jdk25}
    export PATH=$JAVA_HOME/bin:$PATH
    export LD_LIBRARY_PATH="${pkgs.lib.makeLibraryPath javafxDeps}:$LD_LIBRARY_PATH"
  '';
}
