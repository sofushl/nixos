{ pkgs, config, ... }:

{
  programs.neovim = {
    enable = true;
    defaultEditor = true;
    viAlias = true;
    vimAlias = true;
  };
  environment.systemPackages = [
    (pkgs.writeShellScriptBin "vim-inshell" ''
      cd ~/Documents
      nix-shell ~/Documents/nixos/applications/vscodium/java.nix --run 'alacritty -e nvim'
    '')
  ];
}
