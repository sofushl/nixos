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
    in
    {
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

      programs.uv.enable = true;
    };
}
