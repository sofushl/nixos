{
  flake.homeModules.neovim = { pkgs, lib, ... }: {

    home.file = lib.listToAttrs (
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
    );

    programs = {
      neovim = {
        enable = true;
        defaultEditor = true;
        viAlias = true;
        vimAlias = true;
        vimdiffAlias = true;
        waylandSupport = true;

        plugins = with pkgs.vimPlugins; [
          nvim-lspconfig
          nvim-treesitter
          conform-nvim
          blink-cmp

          lualine-nvim
          lualine-lsp-progress
          bufferline-nvim

          nvim-test
          tmux-nvim

          yazi-nvim
          opencode-nvim
          snacks-nvim

          vscode-nvim
        ];

        coc.enable = false;
        withPython3 = false;
        withPerl = false;
        withRuby = false;
        withNodeJs = false;

        initLua = builtins.readFile ../../dotfiles/nvim/init.lua;
      };
    };
  };
}
