{
  flake.nixosModules.develop =
    { userconf, pkgs, ... }:
    {
      programs = {
        npm = {
          enable = true;
          package = pkgs.nodejs_26;
          npmrc = ''
            prefix = ''${HOME}/.npm
            init-license=MIT
            color=true
          '';
        };
      };
    };

  flake.homeModules.dev = { pkgs, ... }: {
    programs = {
      npm = {
        enable = true;
        package = pkgs.nodejs_26;
        settings = {
          color = true;
          include = [
            "dev"
            "prod"
          ];
          init-license = "MIT";
          prefix = "\${HOME}/.npm";
        };
      };

      uv.enable = true;

    };
    home.packages = with pkgs; [
      # Tools
      lazygit
      btop
      git
      curl
      wget
      fd
      ripgrep
      fzf
      unzip
      wget
      curl
      ast-grep
      gzip
      zip
      git-filter-repo
      dnsutils

      # Languages
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
      vscode-langservers-extracted
      tailwindcss-language-server
      yaml-language-server
    ];
  };

}
