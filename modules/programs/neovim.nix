{
  flake.homeModules.neovim = { pkgs, ... }: {
    home.file.".config/nvim/lsp" = {
      source = ../../dotfiles/nvim/lsp;
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
          conform-nvim
          vscode-nvim
          nvim-lspconfig
          blink-cmp
          yazi-nvim
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
