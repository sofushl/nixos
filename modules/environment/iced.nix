{ self, inputs, ... }:

{
  flake.nixosModules.icedDev =
    { lib, pkgs, ... }:
    let
      libs = with pkgs; [
        libxkbcommon
        vulkan-loader
        libGL
        wayland
        libx11
        libxcursor
        libxi
      ];
      rpath = lib.makeLibraryPath libs;
    in
    {
      environment = {
        systemPackages = libs;
        variables = {
          RUSTFLAGS = "-C link-arg=-Wl,-rpath,${rpath}";
        };
      };
    };
}
