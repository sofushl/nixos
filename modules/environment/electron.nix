{ self, inputs, ... }:

{
  flake.nixosModules.electronDev =
    { lib, pkgs, ... }:
    let
      libs = with pkgs; [
        nss
        nspr
        dbus
        gdk-pixbuf
        cups
        pango
        cairo
        expat
        gtk3
        libGL
        libxcb
        alsa-lib
        atk
        libdrm
        libgbm
        libxtst
        libxcomposite
        libxdamage
        libx11
        libxrender
        libxext
        libxi
        libxcursor
        libxrandr
        libxfixes
        libxkbcommon
        glib
      ];
    in
    {
      programs.nix-ld.enable = true;
      programs.nix-ld.libraries = libs;
    };
}
