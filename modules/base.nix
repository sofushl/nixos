{ self, inputs, ... }:

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

      imports = [
        inputs.home-manager.nixosModules.home-manager
        inputs.preservation.nixosModules.default
        inputs.nix-flatpak.nixosModules.nix-flatpak
        inputs.disko.nixosModules.disko
      ];

      # Set locales to Norwegian, but with English language
      time.timeZone = "Europe/Oslo";
      i18n.defaultLocale = "nb_NO.UTF-8";
      i18n.extraLocaleSettings.LANG = "en_GB.UTF-8";
      console.useXkbConfig = true;

      # Kernel
      boot.kernelPackages = pkgs.linuxPackages_latest;

      # Allow unfree packages
      nixpkgs.config.allowUnfree = true;

      # Enable flakes etc.
      nix = {
        #gc.automatic = true;

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
        openssh = {
          enable = true;
          allowSFTP = false;
          openFirewall = false;

          settings = {
            PasswordAuthentication = false;
            KbdInteractiveAuthentication = false;
            PermitRootLogin = "no";
            AllowUsers = [ userconf.username ];
            X11Forwarding = false;
          };
        };

        xserver = {
          xkb = {
            layout = "no";
            variant = "nodeadkeys";
          };
        };
      };

      environment = {
        systemPackages = with pkgs; [
          cacert
          wget
          curl
          git
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

      programs = {
        neovim = {
          enable = true;
          defaultEditor = true;
          viAlias = true;
          vimAlias = true;
        };
        nix-ld.enable = true;

        bash = {
          enable = true;
          interactiveShellInit = "fastfetch";
        };

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
    };
}
