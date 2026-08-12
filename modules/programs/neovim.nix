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
          conform-nvim
          blink-cmp
          vim-test

          lualine-nvim
          bufferline-nvim
          tmux-nvim
          yazi-nvim
          snacks-nvim

          claudecode-nvim

          render-markdown-nvim

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
