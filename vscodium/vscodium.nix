{config, pkgs, ...}:

{

    environment.systemPackages = [ pkgs.vscodium ];

    environment.shellAliases = {
    codium-java = "
     rm -rf ~/.config/VSCodium/Backups && nix-shell ~/Documents/nixos/vscodium/java.nix --run 'codium ~/Documents --ozone-platform=wayland --enable-native-access=javafx.graphics'
    ";

    python-venv = "
    nix-shell -p python314 uv --run ' \
    uv venv --python \$(which python) \
    uv sync '
";

  };

}