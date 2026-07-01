{
  flake.homeModules.neovim = { pkgs, ... }: {
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
}
