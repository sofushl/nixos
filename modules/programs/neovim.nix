# Copyright (C) 2026 Sofus Højberg Lind
# SPDX-License-Identifier: AGPL-3.0-or-later

{
  flake.homeModules.neovim =
    { pkgs, lib, ... }:
    let
      inherit (import ../../lib/pkgs.nix pkgs) mcfunction-grammar mcfunction-lsp;

      dependencies = with pkgs; [
        fd
        ripgrep
        fzf
        zoxide
        resvg
        imagemagick
        ast-grep
        lldpd
        wl-clipboard
        lazygit
      ];
    in
    {
      home.file =
        lib.listToAttrs (
          map
            (path: {
              name = ".config/nvim/${path}";
              value = {
                source = ../../dotfiles/${path};
                force = true;
                recursive = true;
              };
            })
            [
              "lsp"
              "plugin"
            ]
        )
        // {
          ".config/asm-lsp/.asm-lsp.toml".text = ''
            [default_config]
            assembler = "go"
            instruction_set = "riscv"
          '';

          ".config/nvim/parser/mcfunction.so".source = "${mcfunction-grammar}/parser";
          ".config/nvim/queries/mcfunction" = {
            source = "${mcfunction-grammar}/queries/mcfunction";
            recursive = true;
          };
        };

      programs.neovim = {
        enable = true;
        defaultEditor = true;
        viAlias = true;
        vimAlias = true;
        vimdiffAlias = true;
        waylandSupport = true;

        plugins = with pkgs.vimPlugins; [
          conform-nvim
          blink-cmp
          vim-test

          lualine-nvim
          bufferline-nvim
          tmux-nvim
          yazi-nvim
          snacks-nvim
          nvim-highlight-colors

          claudecode-nvim
          opencode-nvim

          render-markdown-nvim
          markdown-preview-nvim
          typst-preview-nvim

          vscode-nvim
        ];

        coc.enable = false;
        withPython3 = false;
        withPerl = false;
        withRuby = false;
        withNodeJs = false;

        initLua = builtins.readFile ../../dotfiles/init.lua;
      };

      home.packages =
        with pkgs;
        [
          # Languages
          lua
          nixd
          go
          typescript

          # Formatter
          nixfmt
          kdlfmt
          yamlfmt
          rustfmt
          prettierd
          black
          isort
          google-java-format
          typstyle
          stylua
          prettierd
          eslint_d

          # LSP
          pyright
          lua-language-server
          nil
          jdt-language-server
          ty
          taplo
          tinymist
          gopls
          vscode-langservers-extracted
          tailwindcss-language-server
          yaml-language-server
          marksman
          mcfunction-lsp
          lemminx
        ]
        ++ dependencies;

    };
}
