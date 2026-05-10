{
  pkgs,
  userconf,
  lib,
  ...
}:

{
  # Set locales to Norwegian, but with English language
  time.timeZone = "Europe/Oslo";
  i18n.defaultLocale = "nb_NO.UTF-8";
  i18n.extraLocaleSettings.LANG = "en_GB.UTF-8";
  console.keyMap = "no";

  # Bootloader
  boot.loader = {
    systemd-boot.enable = !userconf.wsl; # false on WSL
    efi.canTouchEfiVariables = true;
  };

  # Kernel
  boot.kernelPackages = pkgs.linuxPackages_latest;

  # User account
  users.users.${userconf.username} = {
    isNormalUser = true;
    description = userconf.displayname;
    extraGroups = [
      "networkmanager"
      "wheel"
    ];

    openssh.authorizedKeys.keys = userconf.sshkeys;
  };

  # Network setup
  networking.hostName = userconf.hostname;
  networking.networkmanager = {

    enable = lib.mkDefault true;

    settings.connectivity = {
      enabled = true;
      uri = "http://connectivity-check.ubuntu.com/";
      response = "NetworkManager is online";
    };
  };

  # Imports
  imports =
    (if userconf.devenv then [ /${userconf.path}/dev.nix ] else [ ])
    ++ (if userconf.niri then [ /${userconf.path}/niri/niri.nix ] else [ ])
    ++ (if userconf.server then [ /${userconf.path}/server.nix ] else [ ])
    ++ (if userconf.cosmic then [ /${userconf.path}/other/cosmic.nix ] else [ ])
    ++ (if userconf.plasma then [ /${userconf.path}/other/plasma.nix ] else [ ]);

  swapDevices = [
    {
      device = "/var/lib/swapfile";
      size = userconf.swap * 1024;
    }
  ];

  powerManagement.cpuFreqGovernor = "powersave";

  security = {
    rtkit.enable = true;
    sudo.wheelNeedsPassword = false;
    pki.certificateFiles = [ ]; # "/etc/ssl/certs/ca-bundle.crt" "/etc/ssl/certs/ca-certificates.crt" "${pkgs.cacert}/etc/ssl/certs/ca-certificates.crt" "${pkgs.cacert}/etc/ssl/certs/ca-bundle.crt"];
  };

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
  environment = {
    # Package set
    systemPackages = with pkgs; [
      # Terminal applications
      fastfetch
      btop
      nnn

      # Tools
      cacert
      wget
      dnsutils
      git
      openssh
      graphviz
      zip
      uv
      nodejs_25
    ];

    # Custom build commands for using the flake instead of configuration.nix
    shellAliases = {
      nixos-build = ''
        sudo nixos-rebuild switch --flake /${userconf.path}/#${userconf.hostname} --impure
      '';
      nixos-build-boot = ''
        sudo nixos-rebuild boot --flake /${userconf.path}/#${userconf.hostname} --impure
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
      python-venv = ''
        nix-shell -p python314 uv --run ' \
        uv venv --python \$(which python) \
        uv sync'
      '';
      nvim-clear = ''
        rm -rf ~/.config/nvim && \
        rm -rf ~/.cache/nvim && \
        rm -rf ~/.local/share/nvim
      '';
      nixos-userconf = ''
        nixos-allow \
        nvim /etc/nixos/variables.nix
      '';
      nixos-hardwareconf = ''
        nixos-allow \
        nvim /etc/nixos/hardware-configuration.nix
      '';
      git-setup = ''
        git config --global --replace-all user.name "${userconf.displayname}" && \
        git config --global --replace-all user.email "${userconf.gitmail}" && \
        git config --global --get user.name && \
        git config --global --get user.email && \
        ssh-keygen && \
        cat ~/.ssh/*.pub
      '';
    };

    variables = {
      SSL_CERT_FILE = "${pkgs.cacert}/etc/ssl/certs/ca-bundle.crt";
      NIX_SSL_CERT_FILE = "${pkgs.cacert}/etc/ssl/certs/ca-bundle.crt";
    };

  };

  programs = {
    # Global install of neovim to replace nano
    neovim = {
      enable = true;
      defaultEditor = true;
      viAlias = true;
      vimAlias = true;
    };

    nix-ld.enable = true;
  };

  nixpkgs.config = {
    # Force all fetchers to use this CA bundle
    curlOpts = {
      cacert = "${pkgs.cacert}/etc/ssl/certs/ca-bundle.crt";
    };
  };

  services = {
    # Enable sound with pipewire.
    pulseaudio.enable = false;
    pipewire = {
      enable = true;
      alsa.enable = true;
      alsa.support32Bit = true;
      pulse.enable = true;
    };

    # Enable CUPS to print documents.
    printing.enable = true;

    # Thermal security
    thermald.enable = true;
  };

  hardware = {
    bluetooth.enable = true;
    graphics.enable = true;
  };
  # system version variable
  system.stateVersion = userconf.state;
}
