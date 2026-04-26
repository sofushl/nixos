{
  ...
}:

let
  pkgs = import <nixpkgs> { };

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

      LD_LIBRARY_PATH = "${pkgs.lib.makeLibraryPath (dlopenLibraries)}:$LD_LIBRARY_PATH";
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

        # Nvim dependencies
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
      ]
      ++ dlopenLibraries;
  };
}
