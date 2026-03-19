# ~/Documents/nixos/dotfiles/waybar/applets/wifi-picker.sh
# List available Wi-Fi networks
SSID=$(nmcli -t -f SSID dev wifi | rofi -dmenu -p "Wi-Fi")
if [[ -n "$SSID" ]]; then
    nmcli device wifi connect "$SSID"
fi