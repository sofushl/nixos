{ self, inputs, ... }:

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

      environment.systemPackages = with pkgs; [
        # Tools
        lazygit
        btop
        fd
        ripgrep
        fzf
        unzip
        wget
        curl
        ast-grep
        gzip
        gnutar
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
