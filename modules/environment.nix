{
  flake.nixosModules.base =

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
          ripgrep
          btop
          unzip
          dnsutils
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
        };
      };
    };
}
