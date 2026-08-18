{
  flake.nixosModules.micropython =
    # ~/.config/home-manager/modules/python.nix (or inline in home.nix)
    { pkgs, ... }:

    let
      py = pkgs.python314.withPackages (
        ps: with ps; [
          pip
          setuptools
          wheel
          virtualenv
          debugpy
        ]
      );
    in
    {
      environment.systemPackages = [
        py
        pkgs.mpremote # flash/repl/fs over USB-serial, the modern go-to
        pkgs.esptool # if you ever touch ESP32/8266 boards too
        pkgs.picotool # rp2 UF2/bootsel tooling
      ];

    };
}
