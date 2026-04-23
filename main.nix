{
  pkgs,
  userconf,
  config,
  ...
}:

{
  # Bootloader defined in user.nix for wsl purposes, see user_example.nix

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
  services.xserver.xkb = {
    layout = "no";
    variant = "winkeys";
  };

  # Bootloader
  boot.loader.systemd-boot.enable = userconf.bootd; # false on WSL
  boot.loader.efi.canTouchEfiVariables = true;

  # Kernel
  boot.kernelPackages = pkgs.linuxPackages_latest;

  # User account
  users.users.${userconf.username} = {
    isNormalUser = true;
    description = userconf.fullname;
    extraGroups = [
      "networkmanager"
      "wheel"
    ];
  };

  networking.hostName = userconf.hostname;

  # For captive network connection
  programs.captive-browser = {
    enable = true;
    interface = userconf.wifiboard;
  };

  # Imports
  imports =
    userconf.imports
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
  services.thermald.enable = true;

  zramSwap.enable = true;

  # Enable networking
  networking.networkmanager.enable = true;

  networking.networkmanager.settings.connectivity = {
    enabled = true;
    uri = "http://connectivity-check.ubuntu.com/";
    response = "NetworkManager is online";
  };

  #programs.captive-browser.enable = true;

  # Enable bluetooth
  hardware.bluetooth.enable = true;

  # Enable sound with pipewire.
  services.pulseaudio.enable = false;
  security.rtkit.enable = true;
  services.pipewire = {
    enable = true;
    alsa.enable = true;
    alsa.support32Bit = true;
    pulse.enable = true;
    jack.enable = false;
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

  # Custom build commands for using the flake instead of configuration.nix
  environment.shellAliases = {
    nixos-custom = "
      sudo nixos-rebuild switch --flake /home/${userconf.username}/Documents/nixos#${userconf.hostname} --impure
    ";
    nixos-clean = "
      nixos-custom
      sudo nix-collect-garbage -d && \
      sudo nix store optimise && \
      sudo fstrim -av && \
      rm -rf ~/.cache/* ~/.local/share/Trash/* && \
      sudo journalctl --vacuum-time=7d
    ";
    nixos-optimize = "
      nixos-custom
      sudo nix store optimise && \
      sudo fstrim -av && \
      sudo systemctl restart systemd-journald
    ";
    nano = "nvim";
    nixos-allow = ''
      sudo setfacl -R -m u:${userconf.username}:rwx /etc/nixos/ && \
      sudo setfacl -R -m u:${userconf.username}:rwx /home/${userconf.username} 
    '';
    python-venv = "
      nix-shell -p python314 uv --run ' \
      uv venv --python \$(which python) \
      uv sync'
    ";
    nvim-clean = "
      rm -rf ~/.config/nvim && \
      rm -rf ~/.cache/nvim && \
      rm -rf ~/.local/share/nvim
    ";
    nvim-cache = "
      rm -rf ~/.cache/nvim && \
      rm -rf ~/.local/share/nvim
    ";
  };

  # Global install of neovim to replace nano
  programs.neovim = {
    enable = true;
    defaultEditor = true;
    viAlias = true;
    vimAlias = true;
  };

  programs.nano.enable = false;

  # Enable CUPS to print documents.
  services.printing.enable = true;

  #SSH support
  services.openssh.enable = true;

  programs.nix-ld.enable = true;

  hardware.graphics.enable = true;

  # system version variable
  system.stateVersion = userconf.state;
}
