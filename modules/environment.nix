# Copyright (C) 2026 Sofus Højberg Lind
# SPDX-License-Identifier: AGPL-3.0-or-later

# REQUIRES HOME AND NIXOS IMPORT "environment"
{
  flake.nixosModules.environment =

    {
      pkgs,
      config,
      userconf,
      lib,
      ...
    }:
    {
      environment = {
        systemPackages = with pkgs; [
          cacert
          kitty.terminfo
          ncurses
          efibootmgr
          mkpasswd
          sbctl
        ];

        # Custom build commands for using the flake instead of configuration.nix
        shellAliases = {
          nixos = "cd $NIXOS_CONFIG";

          nixos-switch = ''
            git -C ${userconf.path} add -N -A
            sudo nixos-rebuild switch --flake ${userconf.path}/#${userconf.host}'';

          nixos-boot = ''
            git -C ${userconf.path} add -N -A
            sudo nixos-rebuild boot --flake ${userconf.path}/#${userconf.host}'';

          nixos-update = ''
            sudo nix flake update --flake ${userconf.path}
            nixos-switch'';

          nixos-pull = ''
            git -C ${userconf.path} pull
            nixos-switch'';

          nixos-clean = ''
            sudo nix-collect-garbage -d
            sudo nh clean all
            sudo nix store optimise
            sudo fstrim -av
          '';

          mkpin = ''
            sudo install -d -m 0700 -o root -g root /var/lib/secrets

            mkpasswd -m yescrypt | sudo tee /var/lib/secrets/${userconf.username}.hash
            sudo chmod 0400 /var/lib/secrets/${userconf.username}.hash
          '';

          # Eduroam password for the declarative NetworkManager profile
          mkedupass = ''
            sudo install -d -m 0700 -o root -g root /var/lib/secrets
            read -rsp "eduroam password: " p && echo
            printf 'EDUROAM_PASSWORD=%s\n' "$p" | sudo tee /var/lib/secrets/eduroam.env > /dev/null
            unset p
            sudo chmod 0400 /var/lib/secrets/eduroam.env
            sudo systemctl restart NetworkManager-ensure-profiles.service
          '';
        };

        variables = {
          NIXPKGS_ALLOW_UNFREE = 1;
          NIXOS_CONFIG = userconf.path;
        };
      };

      systemd.tmpfiles.rules = [
        "d /etc/nixos 2775 ${userconf.username} wheel -"
        "A+ /etc/nixos - - - - group:wheel:rwX,default:group:wheel:rwX,mask::rwX"
      ];
    };

  flake.homeModules.environment = { pkgs, userconf, ... }: {
    home.packages = with pkgs; [
      btop
      lazygit
      trash-cli
      trickle

      wget
      curl
      gzip
      zip
      ripgrep
      fd
      fzf
      unzip
      imagemagick
      ast-grep
      lldpd
      dnsutils
      pciutils
    ];

    home = {
      shellAliases = {
        home = "cd $HOME_MANAGER_CONFIG";

        home-switch = ''
          git -C ${userconf.path} add -N -A
          nix run nixpkgs#home-manager -- switch --flake ${userconf.path}#${userconf.type}'';

        home-clean = ''
          nix-collect-garbage -d
          nh clean all
          nix store optimise
          sudo fstrim -av
        '';

        home-pull = ''
          git -C ${userconf.path} pull
          home-switch'';

        home-update = ''
          yes | sudo apt update
          yes | sudo apt upgrade
          yes | sudo apt autopurge
          home-pull'';

        home-manager = "home-manager --flake ${userconf.path}#${userconf.type}";
      };
      sessionVariables = {
        NIXOS_OZONE_WL = "1";
        NIXPKGS_ALLOW_UNFREE = 1;
        HOME_MANAGER_CONFIG = userconf.path;
      };
    };
  };
}
