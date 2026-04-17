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
    pkgs.jetbrains.idea-oss

    (pkgs.writeShellScriptBin "codium-inshell" ''
      rm -rf ~/.config/VSCodium/Backups
      nix-shell ~/Documents/nixos/development/shell.nix --run 'codium ~/Documents --ozone-platform=wayland --enable-native-access=javafx.graphics'
    '')

    (pkgs.writeShellScriptBin "idea-inshell" ''
      nix-shell ~/Documents/nixos/development/shell.nix --run 'idea-oss'
    '')

    (pkgs.writeShellScriptBin "nvim-inshell" ''
      nix-shell ~/Documents/nixos/development/shell.nix --run 'alacritty -e "nvim"'
    '')

  ];
}
