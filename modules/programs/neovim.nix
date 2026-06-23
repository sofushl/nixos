{ self, inputs, ... }:

{
  flake.nixosModules.neovim =
    { userconf, pkgs, ... }:

    {
      home-manager.users.${userconf.username} = {

        home.file.".config/nvim/lua" = {
          source = ../../dotfiles/nvim/lua;
          force = true;
          recursive = true;
        };

        programs = {
          neovim = {
            enable = true;
            defaultEditor = true;
            viAlias = true;
            vimAlias = true;
            vimdiffAlias = true;
            waylandSupport = true;

            plugins = with pkgs.vimPlugins; [
              nvim-tree-lua
              neo-tree-nvim
              telescope-nvim
              lazygit-nvim

              vim-plug
              vim-nix
              vim-startify
              conform-nvim

              vscode-nvim

              nvim-lspconfig

              blink-cmp

              nvim-jdtls

              vim-prettier
              vim-javascript
              vim-javascript-syntax
              typescript-vim
              vim-jsx-typescript

              python-mode
              vim-wayland-clipboard

              typst-vim
              typst-preview-nvim

              markdown-preview-nvim
            ];

            extraConfig = "colorscheme vscode";

            coc.enable = false;

            initLua = builtins.readFile ../../dotfiles/nvim/init.lua;
          };
        };
      };

      environment.systemPackages = with pkgs; [
        # Dependencies
        git
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
        zip

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
