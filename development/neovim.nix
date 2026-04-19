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

    plugins = [
      pkgs.nvim-lspconfig
      pkgs.vimPlugins.nvim-treesitter.withAllGrammars
      pkgs.plenary-nvim
      pkgs.gruvbox-material
      pkgs.mini-nvim

    ];

    extraLuaConfig = ''
      require('nvim-treesitter.configs').setup {
        highlight = {
          enable = true,
        },
        indent = {
          enable = true,
        },
      }
    '';
  };
}
