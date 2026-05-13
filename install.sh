#sudo loadkeys no

#nmtui

#sudo mkfs.fat -F 32 -n BOOT /dev/nvme0n1p1
#sudo mkfs.xfs /dev/nvme0n1p4 -L ROOT

sudo mount /dev/disk/by-label/ROOT /mnt
sudo mkdir -p /mnt/boot
sudo mount /dev/disk/by-label/BOOT /mnt/boot
sudo nixos-generate-config --root /mnt

sudo git clone https://github.com/sofuslind/nixos.git
sudo rm /mnt/etc/nixos/configuration.nix
sudo mv /nixos/initconf.nix /mnt/etc/nixos/configuration.nix

cd /mnt
sudo nixos-install