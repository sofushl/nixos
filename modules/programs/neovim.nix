{
  flake.homeModules.neovim =
    { pkgs, lib, ... }:
    let
      micropython-nvim = pkgs.vimUtils.buildVimPlugin {
        name = "micropython-nvim";
        src = pkgs.fetchFromGitHub {
          owner = "jim-at-jibba";
          repo = "micropython.nvim";
          rev = "v2.0.0";
          hash = "sha256-R/YfQWOtUoPxp0s7lOxPIOuPgwuIWk0O5h/EoJGixHw=";
        };
      };

      mcfunction-grammar = pkgs.tree-sitter.buildGrammar {
        language = "mcfunction";
        version = "0.4.0";
        src = pkgs.fetchFromGitHub {
          owner = "bbfh-dev";
          repo = "tree-sitter-mcfunction";
          rev = "d96ad2794d2f3b21f146e3203546ab5776874dac";
          hash = "sha256-JznyZqkk3esSkF93IW5pb/dqLmu3UFwIn1uQWdVCsN4=";
        };
      };

      mcfunction-lsp = pkgs.buildGoModule {
        pname = "mcfunction-lsp";
        version = "unstable-2024-03-20";
        src = pkgs.fetchFromGitHub {
          owner = "mend-lang";
          repo = "mcfunction-lsp";
          rev = "3bc37bc271dce1a3a3a331149cdb17447054ddb6";
          hash = "sha256-xb0BU3MkklR4yzstOTfhy9mIsLv84u6Mpi9u2EjLvTQ=";
        };
        vendorHash = "sha256-qkBpSVLWZPRgS9bqOVUWHpyj8z/nheQJON3vJOwPUj4=";
        subPackages = [ "." ];
      };

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

      nixpkgs.overlays = [
        (final: prev: {
          vimPlugins = prev.vimPlugins.extend (
            vfinal: vprev: {
              conform-nvim = vprev.conform-nvim.overrideAttrs (old: {
                src = prev.fetchFromGitHub {
                  owner = "stevearc";
                  repo = "conform.nvim";
                  rev = "016802de402556da54c36bd7359b441266b01cdd";
                  hash = "sha256-7VkQLpkDak/O5tphT/EWX/rE9r0Dd2UCF5CFbl4rK+A=";
                  fetchSubmodules = false;
                };
              });
            }
          );
        })
      ];

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

          micropython-nvim
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

          # Formatter
          nixfmt
          kdlfmt
          xmlformat
          yamlfmt
          rustfmt
          prettierd
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
          mcfunction-lsp
        ]
        ++ dependencies;

    };
}
