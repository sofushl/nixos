{
  pkgs,
  userconf,
  ...
}:

{
  # Set time zone.
  time.timeZone = "Europe/Oslo";

  # Select internationalisation properties.
  i18n.defaultLocale = "en_GB.UTF-8";

  i18n.extraLocaleSettings = {
    LC_ADDRESS = "nb_NO.UTF-8";
    LC_IDENTIFICATION = "nb_NO.UTF-8";
    LC_MEASUREMENT = "nb_NO.UTF-8";
    LC_MONETARY = "nb_NO.UTF-8";
    LC_NAME = "nb_NO.UTF-8";
    LC_NUMERIC = "nb_NO.UTF-8";
    LC_PAPER = "nb_NO.UTF-8";
    LC_TELEPHONE = "nb_NO.UTF-8";
    LC_TIME = "nb_NO.UTF-8";
  };

  # Keyboard config
  console.keyMap = "no";

  # Bootloader
  boot.loader.systemd-boot.enable = !userconf.wsl; # false on WSL
  boot.loader.efi.canTouchEfiVariables = true;

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
  };

  # Network setup
  networking.hostName = userconf.hostname;
  networking.networkmanager = {

    enable = true;

    settings.connectivity = {
      enabled = true;
      uri = "http://connectivity-check.ubuntu.com/";
      response = "NetworkManager is online";
    };
  };

  # Imports
  imports =
    (
      if userconf.devenv then
        [
          /home/${userconf.username}/Documents/nixos/dev.nix
        ]
      else
        [ ]
    )
    ++ (
      if userconf.niri then
        [
          /home/${userconf.username}/Documents/nixos/niri/niri.nix
        ]
      else
        [ ]
    );

  swapDevices = [
    {
      device = userconf.swapDevice;
      size = userconf.swapSize * 1024;
    }
  ];

  powerManagement.cpuFreqGovernor = "powersave";
  zramSwap.enable = true;

  security = {
    rtkit.enable = true;
    sudo.wheelNeedsPassword = false;
  };

  # Allow unfree packages
  nixpkgs.config.allowUnfree = true;

  # Enable flakes etc.
  nix.settings = {
    experimental-features = [
      "nix-command"
      "flakes"
    ];
  };

  environment = {
    # Package set
    systemPackages =
      with pkgs;
      [
        # Tools
        fastfetch
        btop
        git
        gitui
        openssh
        nixfmt
        tinymist
        kdlfmt
        graphviz
        uv
        nodejs_25
      ]
      ++ (
        if !userconf.wsl then
          [
            # Applications
            onlyoffice-desktopeditors
            vesktop
            spotify
            scenebuilder
            vscodium
            librewolf
            geteduroam
          ]
        else
          [ ]
      );

    # Custom build commands for using the flake instead of configuration.nix
    shellAliases = {
      nixos-build = ''
        sudo nixos-rebuild switch --flake /home/${userconf.username}/Documents/nixos#${userconf.hostname} --impure
      '';
      nixos-build-boot = ''
        sudo nixos-rebuild boot --flake /home/${userconf.username}/Documents/nixos#${userconf.hostname} --impure
      '';
      nixos-clear = ''
        sudo nix-collect-garbage -d && \
        sudo nix store optimise && \
        sudo fstrim -av
      '';
      nixos-clear-cache = ''
        sudo rm -rf -v /home/${userconf.username}/.cache/* /home/${userconf.username}/.local/share/Trash/* && \
        sudo rm -rf -v /tmp/* /var/tmp/* && \
        sudo journalctl --vacuum-time=7d && \
        sudo systemctl restart systemd-journald
      '';
      nano = "nvim";
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
      nixos-system-edit = ''
        nixos-allow \
        nvim /etc/nixos/variables.nix
      '';
      git-setup = ''
        git config --global --replace-all user.name "${userconf.displayname}" && \
        git config --global --replace-all user.email "${userconf.email}" && \
        git config --global --get user.name && \
        git config --global --get user.email && \
        ssh-keygen && \
        cat ~/.ssh/*.pub
      '';
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

    nano.enable = false;
    nix-ld.enable = true;

    # For captive network connection
    captive-browser = {
      enable = true;
      interface = userconf.wifiboard;
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
      jack.enable = false;
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
