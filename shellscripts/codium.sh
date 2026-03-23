rm -rf ~/.config/VSCodium/Backups
nix-shell ~/Documents/nixos/shellscripts/java.nix --run "codium ~/Documents --ozone-platform=wayland --enable-native-access=javafx.graphics"

