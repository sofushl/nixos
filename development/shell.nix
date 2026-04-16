let
  pkgs = import <nixpkgs> { };

  javaFxDeps = with pkgs; [
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
    javaPackages.openjfx25
  ];

  javaEnv = with pkgs; [
    jdk25
    maven
  ];

  rustEnv = with pkgs; [
    rustup
    rustc
    cargo
    rustfmt
    clippy
    rust-analyzer

    # Critical: wayland libraries for runtime
    wayland
    wayland-protocols
    wayland-scanner
    libxkbcommon

    # X11 support
    xorg.libX11
    xorg.libXcursor
    xorg.libXrandr
    xorg.libXi

    # Graphics
    mesa
    libglvnd
    vulkan-loader
    egl-wayland
  ];

  allPackages = javaEnv ++ javaFxDeps; # rust not included currently

in
pkgs.mkShell {
  packages = allPackages;

  shellHook = ''
    export JAVA_HOME=${pkgs.jdk25}
    export PATH="$JAVA_HOME/bin:$PATH"

    # Critical: Set library path for ALL dependencies including wayland/x11
    export LD_LIBRARY_PATH="${
      pkgs.lib.makeLibraryPath (
        allPackages
        ++ [
          pkgs.wayland
          pkgs.libxkbcommon
          pkgs.mesa
          pkgs.vulkan-loader
        ]
      )
    }:$LD_LIBRARY_PATH"

    export TMPDIR=$PWD/.tmp
    mkdir -p $TMPDIR
  '';
}
