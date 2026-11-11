# Copyright (C) 2026 Sofus Højberg Lind
# SPDX-License-Identifier: AGPL-3.0-or-later

{
  lib,
  ...
}:
{
  options.flake.homeModules = lib.mkOption {
    type = lib.types.lazyAttrsOf lib.types.unspecified;
    default = { };
    description = "Pure home-manager modules, usable on any system.";
  };

  options.flake.homeConfigurations = lib.mkOption {
    type = lib.types.lazyAttrsOf lib.types.unspecified;
    default = { };
    description = "Standalone home-manager configurations (Ubuntu, etc.)";
  };
}
