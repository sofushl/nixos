{ self, ... }:
{
  flake.homeModules.develop = { pkgs, ... }: {
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
