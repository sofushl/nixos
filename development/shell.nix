let
  pkgs = import <nixpkgs> { };

  javaFxDeps = with pkgs; [

    javaPackages.openjfx25

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
    xorg.libXxf86vm
    xorg.libXfixes
    xorg.libXinerama

    wayland
    libxkbcommon
    vulkan-loader
  ];

  javaEnv = with pkgs; [
    jdk25
    maven
  ];

  dlopenLibraries = with pkgs; [
    libxkbcommon

    # GPU backend
    vulkan-loader
    # libGL

    # Window system
    wayland
    # xorg.libX11
    # xorg.libXcursor
    # xorg.libXi
  ];

  allPackages = javaEnv ++ javaFxDeps;

in
pkgs.mkShell {
  packages = allPackages;

  nativeBuildInputs = with pkgs; [
    cargo
    rustc
  ];

  # additional libraries that your project
  # links to at build time, e.g. OpenSSL
  buildInputs = [ ];

  env.RUSTFLAGS = "-C link-arg=-Wl,-rpath,${pkgs.lib.makeLibraryPath dlopenLibraries}";

  shellHook = ''
    export JAVA_HOME=${pkgs.jdk25}
    export PATH="$JAVA_HOME/bin:$PATH"

    # Critical: Set library path for ALL dependencies including wayland/x11
    export LD_LIBRARY_PATH="${pkgs.lib.makeLibraryPath (allPackages)}:$LD_LIBRARY_PATH"

    export TMPDIR=$PWD/.tmp
    mkdir -p $TMPDIR
  '';
}
