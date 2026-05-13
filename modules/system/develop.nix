{ self, inputs, ... }:

{
  flake.nixosModules.develop =
    {
      lib,
      pkgs,
      ...
    }:

    let
      dlopenLibraries = with pkgs; [
        pipewire
        javaPackages.openjfx25
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
        mesa
        wayland
        libxkbcommon
        vulkan-loader
      ];

    in
    {

      environment = {
        variables = {

          RUSTFLAGS = "-C link-arg=-Wl,-rpath,${pkgs.lib.makeLibraryPath dlopenLibraries}";

          JAVA_HOME = pkgs.javaPackages.compiler.openjdk25;

          RPATH = "${pkgs.lib.makeLibraryPath dlopenLibraries}";

          LD_LIBRARY_PATH = pkgs.lib.mkForce (pkgs.lib.makeLibraryPath dlopenLibraries);

        };

        systemPackages =
          with pkgs;
          [
            # Languages
            javaPackages.compiler.openjdk25
            maven
            rustc
            cargo
            lua
            gcc

            # LSP
            stylua
            pyright
            lua-language-server
            nil
            rust-analyzer
            jdt-language-server
            typescript-language-server
            lldpd
            ty
            taplo
            clang-tools
            tinymist
            vscode-css-languageserver

            # Formatter
            nixfmt
            kdlfmt
            rustfmt
            prettierd
            prettier
            black
            isort

            # Nvim dependencies
            tree-sitter
            telescope
            lazygit
            fd
            ripgrep
            fzf
            unzip
            wget
            curl
            ast-grep
            gzip
            gnutar

            # Other tools
            uv
            graphviz
          ]
          ++ dlopenLibraries;
      };

      services.pipewire.jack.enable = lib.mkForce false;
    };
}
