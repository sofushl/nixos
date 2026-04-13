{ config, pkgs, ... }:

{

  environment.shellAliases = {
    python-venv = "
    nix-shell -p python314 uv --run ' \
    uv venv --python \$(which python) \
    uv sync '
";
  };

  environment.systemPackages = [
    pkgs.vscodium
    #pkgs.jdk25

    (pkgs.writeShellScriptBin "codium-java" ''
      rm -rf ~/.config/VSCodium/Backups
      nix-shell ~/Documents/nixos/vscodium/java.nix --run 'codium ~/Documents --ozone-platform=wayland --enable-native-access=javafx.graphics'
    '')

    # Dependencies for the shell java.nix
    # pkgs.gtk3
    # pkgs.glib
    # pkgs.libGL
    # pkgs.libglvnd
    # pkgs.libpulseaudio
    # pkgs.libva
    # pkgs.xorg.libX11
    # pkgs.xorg.libXtst
    # pkgs.xorg.libXrender
    # pkgs.xorg.libXext
    # pkgs.xorg.libXi
    # pkgs.xorg.libXcursor
    # pkgs.xorg.libXrandr
    # pkgs.xorg.libXxf86vm
    # pkgs.xorg.libXfixes
    # pkgs.xorg.libXinerama
    # pkgs.javaPackages.openjfx25
    # pkgs.maven
    # pkgs.nodejs_24
  ];
}
