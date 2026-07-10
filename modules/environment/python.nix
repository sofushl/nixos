{
  flake.homeModules.micropython =
    # ~/.config/home-manager/modules/python.nix (or inline in home.nix)
    { pkgs, ... }:

    let
      py = pkgs.python312.withPackages (
        ps: with ps; [
          pip
          setuptools
          wheel
          virtualenv
        ]
      );
    in
    {
      home.packages = [
        py
        pkgs.mpremote # flash/repl/fs over USB-serial, the modern go-to
        pkgs.esptool # if you ever touch ESP32/8266 boards too
        pkgs.picotool # rp2 UF2/bootsel tooling
        pkgs.python313Packages.debugpy
      ];

      home.sessionVariables = {
        # optional: keep pip from ever touching a "system" env, forces venv discipline
        # PIP_REQUIRE_VIRTUALENV = "true";
      };
    };
}
