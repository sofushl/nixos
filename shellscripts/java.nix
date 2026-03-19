let
  pkgs = import <nixpkgs> { };

  customJava = pkgs.jdk25;

  javafxDeps = with pkgs; [
    gtk3
    glib
    libGL
    libglvnd
    libpulseaudio
    libva
    xorg.libX11
    xorg.libXtst
    xorg.libXrender
    xorg.libXext
    xorg.libXi
    xorg.libXcursor
    xorg.libXrandr
    javaPackages.compiler.openjdk25
    javaPackages.openjfx25
    maven
  ];
in
pkgs.mkShell {
  packages = [ customJava ] ++ javafxDeps;

  shellHook = ''
    export JAVA_HOME=${customJava}
    export PATH=$JAVA_HOME/bin:$PATH
    export LD_LIBRARY_PATH="${pkgs.lib.makeLibraryPath javafxDeps}:$LD_LIBRARY_PATH"
  '';
}
