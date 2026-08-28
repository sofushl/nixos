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
      # Set locales to Norwegian, but with English language
      time.timeZone = "Europe/Oslo";
      i18n.defaultLocale = "nb_NO.UTF-8";
      i18n.extraLocaleSettings.LANG = "en_GB.UTF-8";
      console.useXkbConfig = true;

      users.users.root.hashedPassword = userconf.pinhash;
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
          sandbox = true;
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
    };

  flake.homeModules.base =

    {
      pkgs,
      config,
      userconf,
      lib,
      ...
    }:
    {

      programs.home-manager = {
        enable = true;
      };

      targets.genericLinux = {
        enable = true;
        gpu.enable = true;
        nixGL.vulkan.enable = true;
      };
    };
}
