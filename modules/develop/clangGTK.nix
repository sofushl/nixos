{
  flake.nixosModules.clangGTK =
    {
      config,
      userconf,
      pkgs,
      ...
    }:
    let
      libs = with pkgs; [
        gcc
        clang
        clang-tools
        cmake
        gnumake

        pkg-config

        gtk4.dev
        glib.dev
        pango.dev
        cairo.dev
        harfbuzz.dev
        gdk-pixbuf.dev
        graphene.dev
        libepoxy.dev
        wayland.dev
        libxkbcommon.dev
        fribidi.dev

        vulkan-loader
        vulkan-loader.dev
        vulkan-headers
      ];
    in
    {
      environment = {
        systemPackages = libs;
        variables.PKG_CONFIG_PATH = "/run/current-system/sw/lib/pkgconfig:/run/current-system/sw/share/pkgconfig";
        variables.CMAKE_EXPORT_COMPILE_COMMANDS = "ON";
      };

      programs.nix-ld.enable = true;
      programs.nix-ld.libraries = libs;
    };
}
