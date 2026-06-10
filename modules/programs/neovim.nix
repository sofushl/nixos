{ self, inputs, ... }:

{
  flake.nixosModules.neovim =
    { userconf, pkgs, ... }:

    {
      home-manager.users.${userconf.username}.programs = {

        neovim = {
          enable = true;
          #defaultEditor = true;
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

          initLua = builtins.readFile ../../dotfiles/neovim.lua;
        };

        helix = {
          enable = true;
          defaultEditor = true;
          settings = {
            theme = "gruvbox-material";
          };
        };

        yazi = {
          # https://kb.adamsdesk.com/application/yazi-keyboard-shortcuts/
          enable = true;
          enableBashIntegration = true;
          enableZshIntegration = true;
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
      ];
    };
}
