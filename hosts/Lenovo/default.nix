{
  imports = [
    ./hardware.nix

    ../presets/homeserver.nix
  ];

  networking.hostName = "Lenovo";
}
