{
  flake.nixosModules.rustWASM =
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
        systemPackages =
          with pkgs;
          [
            rustc
            cargo
            clippy
            rust-analyzer
            rustlings

            cargo-generate
            pkg-config
            openssl

            lld
            trunk
            wasm
            cargo-wasi
            wasm-bindgen-cli
            tailwindcss_4
          ]
          ++ libs;
        variables = {
          RUSTFLAGS = "-C link-arg=-Wl,-rpath,${rpath}";
        };
      };
      programs.nix-ld.enable = true;
      programs.nix-ld.libraries = libs;
    };
}
