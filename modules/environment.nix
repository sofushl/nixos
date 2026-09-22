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
          wget
          curl
          gzip
          zip
          git-filter-repo
          git-secrets
          ripgrep
          fd
          fzf
          btop
          unzip
          dnsutils
          trash-cli
        ];

        # Custom build commands for using the flake instead of configuration.nix
        shellAliases = {

          nixos-switch = ''
            git -C /${userconf.path} add -N -A
            sudo nixos-rebuild switch --flake /${userconf.path}/#${userconf.host} --impure
          '';

          nixos-boot = ''
            git -C /${userconf.path} add -N -A
            sudo nixos-rebuild boot --flake /${userconf.path}/#${userconf.host} --impure
          '';

          nixos-update = ''
            sudo nix flake update --flake /${userconf.path}
            nixos-switch
          '';

          nixos-pull = ''
            git -C /${userconf.path} pull
            nixos-switch
          '';

          nix-clear = ''
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

        enableAllTerminfo = true;
      };
    };

  flake.homeModules.environment = { pkgs, userconf, ... }: {
    home.packages = with pkgs; [
      wget
      curl
      gzip
      zip
      git-filter-repo
      git-secrets
      ripgrep
      fd
      fzf
      btop
      unzip
      dnsutils
      trash-cli
    ];

    home = {
      shellAliases = {
        home-switch = ''
          git -C /${userconf.path} add -N -A
          nix run nixpkgs#home-manager -- switch --flake /${userconf.path}#${userconf.type} -b back
        '';

        nix-clear = ''
          nix-collect-garbage -d
          nh clean all
          nix store optimise
          sudo fstrim -av
        '';

        home-pull = ''
          git -C /${userconf.path} pull
          home-switch
        '';

        home-manager = "home-manager --flake /${userconf.path}#${userconf.type}";
      };
      sessionVariables = {
        NIXOS_OZONE_WL = "1";
      };
    };
  };
}
