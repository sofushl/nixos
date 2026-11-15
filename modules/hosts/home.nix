# Copyright (C) 2026 Sofus Højberg Lind
# SPDX-License-Identifier: AGPL-3.0-or-later

{ self, inputs, ... }:
let
  homes = import ../../lib/homes.nix;
  resolvehome = builtins.mapAttrs (_: h: homes.default // h) homes.homes;
  sshkeys = import ../../lib/sshkeys.nix;
  theme = import ../../lib/theme.nix;
  serverconf = import ../../lib/server.nix { inherit nixpkgs pkg; };
  pkg = import inputs.stablepkgs {
    system = "x86_64-linux";
    config.allowUnfree = true;
    config.cudaSupport = true;
  };
  nixpkgs = import inputs.nixpkgs {
    system = "x86_64-linux";
    config.allowUnfree = true;
    config.cudaSupport = true;
  };
in
{
  flake.homeConfigurations = builtins.mapAttrs (
    type: homeconf:
    inputs.home-manager.lib.homeManagerConfiguration {
      inherit pkg;

      extraSpecialArgs = {
        inherit inputs pkg;
        userconf = homeconf // theme // sshkeys // serverconf;
      };

      modules = [ self.homeModules.${homeconf.type} ];
    }
  ) resolvehome;
}
