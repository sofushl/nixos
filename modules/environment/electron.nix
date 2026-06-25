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

      environment = {
        systemPackages = libs;
        variables.LD_LIBRARY_PATH = lib.mkAfter (lib.makeLibraryPath libs);
      };
    };
}
