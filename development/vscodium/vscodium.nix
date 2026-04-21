{ config, pkgs, ... }:

{
  environment.shellAliases = {
    python-venv = "
    nix-shell -p python314 uv --run ' \
    uv venv --python \$(which python) \
    uv sync'
    ";
    nvim-clean = "
      rm -rf ~/.config/nvim && \
      rm -rf ~/.cache/nvim && \
      rm -rf ~/.local/share/nvim
    ";
    nvim-cache = "
      rm -rf ~/.cache/nvim && \
      rm -rf ~/.local/share/nvim
    ";
  };

  environment.systemPackages = [
    pkgs.vscodium
    pkgs.jetbrains.idea-oss

    (pkgs.writeShellScriptBin "codium-inshell" ''
      codium ~/Documents --ozone-platform=wayland --enable-native-access=javafx.graphics
    '')

    (pkgs.writeShellScriptBin "idea-inshell" ''
      idea-oss ~/Documents/HorseStatisticsManager
    '')

    (pkgs.writeShellScriptBin "nvim-inshell" ''
      alacritty -e "nvim"
    '')

  ];
}
