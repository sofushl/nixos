{
  imports = [
    /etc/nixos/hardware-configuration.nix

    ../presets/homeserver.nix
  ];

  networking.hostName = "Lenovo";
}
