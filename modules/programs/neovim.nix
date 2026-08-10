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

        plugins =
          let
            blink-cmp-claude = pkgs.vimUtils.buildVimPlugin {
              pname = "blink-cmp-claude";
              version = "unstable-2026-08-09";
              src = pkgs.fetchFromGitHub {
                owner = "saiashirwad";
                repo = "blink-cmp-claude";
                rev = "main";
                hash = "sha256-Uq+bA7TL2FgfL7W42/pTOb3Eqg1RHrqRLTJJz8+C3kA=";
              };
            };
          in
          with pkgs.vimPlugins;
          [
            nvim-lspconfig
            conform-nvim
            blink-cmp
            vim-test

            lualine-nvim
            bufferline-nvim
            tmux-nvim
            yazi-nvim
            snacks-nvim

            opencode-nvim
            claudecode-nvim
            blink-cmp-claude

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
