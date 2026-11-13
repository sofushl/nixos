# Copyright (C) 2026 Sofus Højberg Lind
# SPDX-License-Identifier: AGPL-3.0-or-later

{ self, inputs, ... }:
let
  system = "x86_64-linux";
  nixpkgs = import inputs.nixpkgs {
    inherit system;
    config.allowUnfree = true;
  };
  homes = import ../../lib/homes.nix;
  resolvehome = builtins.mapAttrs (_: h: homes.default // h) homes.homes;
  pkgs = import inputs.pkgs {
    system = pkgs.stdenv.hostPlatform.system;
    config.allowUnfree = true;
    config.cudaSupport = true;
  };
  sshkeys = import ../../lib/sshkeys.nix;
  theme = import ../../lib/theme.nix;
  serverconf = import ../../lib/server.nix { inherit nixpkgs pkgs; };
in
{
  flake.homeConfigurations = builtins.mapAttrs (
    type: homeconf:
    inputs.home-manager.lib.homeManagerConfiguration {
      inherit pkgs;

      extraSpecialArgs = {
        inherit inputs pkgs;
        userconf = homeconf // theme // sshkeys // serverconf;
      };

      modules = [ self.homeModules.${homeconf.type} ];
    }
  ) resolvehome;
}
