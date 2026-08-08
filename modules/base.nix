{ inputs, ... }:

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

      imports = [ inputs.home-manager.nixosModules.home-manager ];

      # Set locales to Norwegian, but with English language
      time.timeZone = "Europe/Oslo";
      i18n.defaultLocale = "nb_NO.UTF-8";
      i18n.extraLocaleSettings.LANG = "en_GB.UTF-8";
      console.useXkbConfig = true;

      boot.kernelPackages = pkgs.linuxPackages_latest;
      networking.hostName = userconf.host;
      system.stateVersion = userconf.state;

      nixpkgs.config.allowUnfree = true;

      nix = {
        settings = {
          experimental-features = [
            "nix-command"
            "flakes"
          ];
          sandbox = false;
          auto-optimise-store = true;
        };
      };

      security = {
        rtkit.enable = true;
        sudo.wheelNeedsPassword = false;
      };

      services = {

        xserver = {
          xkb = {
            layout = "no";
            variant = "nodeadkeys";
          };
        };
      };

      programs = {
        neovim = {
          enable = true;
          defaultEditor = true;
          viAlias = true;
          vimAlias = true;
        };

        nix-ld.enable = true;

        git = {
          enable = true;

          config = {
            user = {
              name = userconf.displayname;
              email = userconf.gitmail;
            };

            init.defaultBranch = "main";
            core.editor = "nvim";
          };
        };
      };

      environment = {
        systemPackages = with pkgs; [
          cacert
          wget
          curl
        ];

        # Custom build commands for using the flake instead of configuration.nix
        shellAliases = {

          nixos-switch = "
          git -C /${userconf.path} add -A
          sudo nixos-rebuild switch --flake /${userconf.path}/#${userconf.host} --impure";

          nixos-boot = ''
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
