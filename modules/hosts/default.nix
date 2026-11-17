# Copyright (C) 2026 Sofus Højberg Lind
# SPDX-License-Identifier: AGPL-3.0-or-later

{
  self,
  inputs,
  lib,
  ...
}:
let
  hosts = import ../../lib/hosts.nix;
  resolved = builtins.mapAttrs (_: h: hosts.default // h) hosts.hosts;
  sshkeys = import ../../lib/sshkeys.nix;
  theme = import ../../lib/theme.nix;
  homes = import ../../lib/homes.nix;
  resolvehome = builtins.mapAttrs (_: h: homes.default // h) homes.homes;
  stripNulls = lib.filterAttrs (_: v: v != null && v != "");
  secrets =
    if builtins.pathExists /etc/nixos/secrets.nix then
      import /etc/nixos/secrets.nix
    else
      {
        dnsUpdateLinks = [ ];
        secretServices = [ ];
      };

  # One nixpkgs instance per system. CUDA is enabled only when the system has NVIDIA.
  mkPkgs = nvidia: {
    pkgs = import inputs.nixpkgs {
      system = "x86_64-linux";
      overlays = [
        inputs.nix-vscode-extensions.overlays.default
        inputs.nix-minecraft.overlay
      ];
      config = {
        allowUnfree = true;
        cudaSupport = nvidia;
      };
    };
    spkg = import inputs.stablepkgs {
      system = "x86_64-linux";
      config = {
        allowUnfree = true;
        cudaSupport = nvidia;
      };
    };
  };
in
{
  flake.nixosConfigurations = builtins.mapAttrs (
    hostname: sysconf:
    let
      inherit (mkPkgs sysconf.nvidia) pkgs spkg;
      serverconf = import ../../lib/server.nix { inherit pkgs spkg; };
    in
    inputs.nixpkgs.lib.nixosSystem {
      system = sysconf.system;

      specialArgs = {
        inherit inputs spkg;
        userconf =
          theme // sshkeys // stripNulls (resolvehome.${sysconf.home}) // sysconf // serverconf // secrets;
      };

      modules = [
        { nixpkgs.pkgs = pkgs; }
        self.nixosModules.${sysconf.host}
      ];
    }
  ) resolved;

  # Standalone Home Manager (no NixOS). Uses the nvidia flag of the home entry.
  flake.homeConfigurations = builtins.mapAttrs (
    type: homeconf:
    let
      inherit (mkPkgs homeconf.nvidia) pkgs spkg;
      serverconf = import ../../lib/server.nix { inherit pkgs spkg; };
    in
    inputs.home-manager.lib.homeManagerConfiguration {
      inherit pkgs;

      extraSpecialArgs = {
        inherit inputs spkg;
        userconf = homeconf // theme // sshkeys // serverconf;
      };

      modules = [ self.homeModules.${homeconf.type} ];
    }
  ) resolvehome;
}
