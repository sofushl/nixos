{ self, inputs, ... }:

{
  flake.nixosModules.electronWSL =
    { lib, pkgs, ... }:

    let
      lib = with pkgs; [
        nss
        nspr
        dbus
        gdk-pixbuf
        pango
        cairo
        expat
        libxcb
        alsa-lib
        atk
        libdrm
        libgbm
        libxtst
        libxcomposite
        libxdamage
      ];
    in
    {
      environment.systemPackages = lib;
    };
}
