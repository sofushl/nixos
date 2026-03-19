#This shell is good as is, you don't need to change anything.
let
  pkgs = import <nixpkgs> { };

  #We make a custom Java environment which forces JavaFX by overriding, to  enabeled the Java libraries
  customJava = pkgs.jdk21.override {
    enableJavaFX = true;
  };

  javafxLibs = with pkgs; [
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
    mesa
    libxxf86vm
    libx11
    libxext
    libxrender
    libxtst
    libxi
  ];
in
pkgs.mkShell {
  packages = [ customJava ] ++ javafxLibs;

  shellHook = ''
    export JAVA_HOME=${customJava}
    export PATH=$JAVA_HOME/bin:$PATH
    export LD_LIBRARY_PATH="${pkgs.lib.makeLibraryPath javafxLibs}:$LD_LIBRARY_PATH"

    echo "✅ JavaFX development shell ready. JAVA_HOME is set to $JAVA_HOME"
  '';
}

#Execute by cd into the folder and run nix-shell, first run will download the libraries
