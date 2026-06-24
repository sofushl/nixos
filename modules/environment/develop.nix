{ self, inputs, ... }:

{
  flake.nixosModules.develop =
    { lib, pkgs, ... }:

    let
      javafxLib = with pkgs; [

        javaPackages.openjfx25
        mesa

        gtk3
        glib
        libGL
        libglvnd
        libpulseaudio
        libva
        libx11
        libxtst
        libxrender
        libxext
        libxi
        libxcursor
        libxrandr
        libxxf86vm
        libxfixes
        libxinerama

        pipewire
      ];

      icedLib = with pkgs; [
        libxkbcommon

        # GPU backend
        vulkan-loader
        libGL

        # Window system
        wayland
        libx11
        libxcursor
        libxi
      ];

      jdkWithFX = pkgs.openjdk.override {
        enableJavaFX = true; # for JavaFX
        # include following line if JavaFX with Webkit is needed
        # openjfx_jdk = pkgs.openjfx.override { withWebKit = true; };
      };

    in
    {
      environment = {
        variables = {

          RUSTFLAGS = "-C link-arg=-Wl,-rpath,${pkgs.lib.makeLibraryPath javafxLib}";

          JAVA_HOME = pkgs.javaPackages.compiler.openjdk25;

          RPATH = "${pkgs.lib.makeLibraryPath javafxLib}";

          LD_LIBRARY_PATH = pkgs.lib.mkForce (pkgs.lib.makeLibraryPath icedLib);

        };

        systemPackages =
          with pkgs;
          [
            # Languages
            jdkWithFX
            javaPackages.compiler.openjdk25
            maven
            rustc
            cargo
            lua
            gcc
            nixd
            typescript

            # Formatter
            nixfmt
            kdlfmt
            yamlfmt
            rustfmt
            prettierd
            prettier
            eslint
            black
            isort
            google-java-format

            # Tools
            nodejs_22
            uv
            git-filter-repo
          ]
          ++ javafxLib
          ++ icedLib;
      };

      services.pipewire.jack.enable = lib.mkForce false;
    };
}
