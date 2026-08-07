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
          conform-nvim
          blink-cmp

          yazi-nvim
          opencode-nvim
          snacks-nvim

          vscode-nvim
        ];

        extraConfig = "colorscheme vscode";

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
