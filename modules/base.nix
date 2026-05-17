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
        gc.automatic = true;

        settings = {
          experimental-features = [
            "nix-command"
            "flakes"
          ];
          sandbox = false;
          auto-optimise-store = true;
        };
      };

      users.mutableUsers = false;

      security = {
        rtkit.enable = true;
        sudo.wheelNeedsPassword = false;
        pki.certificateFiles = [ ]; # "/etc/ssl/certs/ca-bundle.crt" "/etc/ssl/certs/ca-certificates.crt" "${pkgs.cacert}/etc/ssl/certs/ca-certificates.crt" "${pkgs.cacert}/etc/ssl/certs/ca-bundle.crt"];
      };

      services = {
        openssh = {
          enable = true;
          allowSFTP = true;

          settings = {
            PasswordAuthentication = false;
            PermitRootLogin = "no";
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
        # Package set
        systemPackages = with pkgs; [
          # Terminal applications
          fastfetch
          btop
          nnn
          agenix-cli

          # Tools
          cacert
          wget
          curl
          dnsutils
          ripgrep
          git
          git-filter-repo
          zip
          unzip
          gzip
          nodejs_25
          uv
        ];

        # Custom build commands for using the flake instead of configuration.nix
        shellAliases = {
          nixos-build = ''
            sudo nixos-rebuild switch --flake /${userconf.path}/#${config.networking.hostName} --impure
          '';
          nixos-build-boot = ''
            sudo nixos-rebuild boot --flake /${userconf.path}/#${config.networking.hostName} --impure
          '';
          nixos-clear = ''
            sudo nix-collect-garbage -d && \
            sudo rm -rf -v /home/${userconf.username}/.cache/* /home/${userconf.username}/.local/share/Trash/* && \
            sudo nix store optimise && \
            sudo fstrim -av
          '';
          nixos-allow = ''
            sudo setfacl -R -m u:${userconf.username}:rwx /etc/nixos/ && \
            sudo setfacl -R -m u:${userconf.username}:rwx /home/${userconf.username}/Documents
          '';
          nixos-secrets = ''
            nixos-allow \
            nvim /etc/nixos/secrets.nix
          '';
        };

        variables = {
          SSL_CERT_FILE = "${pkgs.cacert}/etc/ssl/certs/ca-bundle.crt";
          NIX_SSL_CERT_FILE = "${pkgs.cacert}/etc/ssl/certs/ca-bundle.crt";
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
      };

    };
}
