# REQUIRES HOME AND NIXOS IMPORT "base"
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

      users.users.root.hashedPasswordFile = "/var/lib/secrets/root.hash";
      security.sudo.wheelNeedsPassword = true;

      system.activationScripts.pinfile.text = ''
        install -d -m 0700 -o root -g root /var/lib/secrets
        if [ ! -s /var/lib/secrets/${userconf.username}.hash ]; then
          umask 077
          ${pkgs.mkpasswd}/bin/mkpasswd -m yescrypt p > /var/lib/secrets/${userconf.username}.hash
          chmod 0400 /var/lib/secrets/${userconf.username}.hash
        fi
        if [ ! -s /var/lib/secrets/root.hash ]; then
          install -m 0400 -o root -g root /var/lib/secrets/${userconf.username}.hash /var/lib/secrets/root.hash
        fi
      '';

      system.activationScripts.users.deps = [ "pinfile" ];

      boot.kernelPackages = pkgs.linuxPackages_latest;

      networking.hostName = userconf.host;
      system.stateVersion = userconf.state;

      nixpkgs = {
        hostPlatform = userconf.system;
        config.allowUnfree = true;
      };

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

      services = {
        xserver = {
          xkb = {
            layout = "no";
            variant = "nodeadkeys";
          };
        };
        gnome.gnome-keyring.enable = true;
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
              email = userconf.email;
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
      nixpkgs.config.allowUnfree = true;

      programs.home-manager = {
        enable = true;
      };

      targets.genericLinux = {
        enable = true;
        gpu.enable = true;
        nixGL.vulkan.enable = true;
      };

      home.stateVersion = userconf.state;
    };
}
