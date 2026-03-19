
clean() {
    sudo nix-store --optimise
    sudo nix-collect-garbage -d
    sudo /run/current-system/bin/switch-to-configuration boot
    sudo find /tmp -mindepth 1 -delete
    sudo find /var/tmp -mindepth 1 -delete  
    rm -rf ~/.cache/*
    sudo rm -rf /var/cache/*
    #sudo journalctl --vacuum-time=7d    
}

clean

sudo nixos-rebuild switch

clean