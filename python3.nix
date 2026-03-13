{ config, pkgs, ... }:

{

  # For UV usage
  programs.nix-ld.enable = true;

  # Python with jupyter notebook
  environment.systemPackages = with pkgs; [
    python313
    python313Packages.jupyter-core
    python313Packages.notebook
    python313Packages.pip
    python313Packages.uv

  ];
}
