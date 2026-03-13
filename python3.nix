{ config, pkgs, ... }:

# Ss far as I know, I can't get this working and Im giving up

{
  environment.systemPackages = with pkgs; [
    python313
    uv
  ];

  programs.nix-ld = {
    enable = true;
    libraries = with pkgs; [
      stdenv.cc.cc
      zlib
      openssl
    ];
  };
}
