{ self, ... }:

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
        gcc
        clang
        clang-tools
        cmake

        fd
        fzf
        ripgrep
      ];

      home-manager.users.${userconf.username}.imports = [ self.homeModules.dev ];
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

    imports = with self.homeModules; [
      neovim
      yazi
      claude
      git
      bash
      fastfetch
    ];

    home.packages = with pkgs; [
      # Tools
      lazygit
      imagemagick
      ast-grep
      lldpd

      # Languages
      lua
      nixd
      typescript
      typst

      # Formatter
      nixfmt
      kdlfmt
      yamlfmt
      rustfmt
      clippy
      prettierd
      prettier
      eslint
      black
      isort
      google-java-format
      typstyle
      stylua

      # LSP
      pyright
      lua-language-server
      nil
      jdt-language-server
      typescript-language-server
      ty
      taplo
      tinymist
      vscode-langservers-extracted
      tailwindcss-language-server
      yaml-language-server
      marksman
      asm-lsp
    ];

    home.file.".config/asm-lsp/.asm-lsp.toml".text = ''
      [default_config]
      assembler = "go"
      instruction_set = "riscv"
    '';
  };

}
