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
                source = ../../dotfiles/nvim/${path};
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

        initLua = builtins.readFile ../../dotfiles/nvim/init.lua;
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
        ]
        ++ dependencies;

    };
}
