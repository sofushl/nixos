{
  config,
  pkgs,
  lib,
  ...
}:

let
  pkgs = import <nixpkgs> { };

  dlopenLibraries = with pkgs; [
    pipewire
    javaPackages.openjfx25
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
    mesa
    wayland
    libxkbcommon
    vulkan-loader
  ];

in
{
  environment.systemPackages =
    with pkgs;
    [
      javaPackages.compiler.openjdk25
      maven
      rustc
      cargo
    ]
    ++ dlopenLibraries;

  environment.variables = {

    RUSTFLAGS = "-C link-arg=-Wl,-rpath,${pkgs.lib.makeLibraryPath dlopenLibraries}";

    JAVA_HOME = pkgs.javaPackages.compiler.openjdk25;

    RPATH = "${pkgs.lib.makeLibraryPath dlopenLibraries}";

    LD_LIBRARY_PATH = "${pkgs.lib.makeLibraryPath (dlopenLibraries)}:$LD_LIBRARY_PATH";
  };
}
