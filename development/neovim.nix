{
  config,
  pkgs,
  home-manager,
  ...
}:

{
  programs.neovim = {
    enable = true;
    defaultEditor = true;

    plugins = with pkgs.vimPlugins; [
      nvim-lspconfig
      nvim-treesitter.withAllGrammars
      plenary-nvim
      gruvbox-material
      mini-nvim

    ];

    initLua = ''
      require('nvim-treesitter.configs').setup {
        highlight {
          enable = true,
        },
        indent = {
          enable = true,
        },
      }
    '';
  };
}
