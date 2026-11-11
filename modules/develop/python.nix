# Copyright (C) 2026 Sofus Højberg Lind
# SPDX-License-Identifier: AGPL-3.0-or-later

{
  flake.nixosModules.python =
    { pkgs, ... }:

    let
      py = pkgs.python314.withPackages (
        ps: with ps; [
          pip
          setuptools

          wheel
          virtualenv
          debugpy

          matplotlib
          numpy
          pandas
          numba

          requests

          pygame
          seaborn

          jupyter
          ipykernel
          ipywidgets
          notebook

          scikit-learn
          statsmodels

          keyboard
          kernels
        ]
      );
    in
    {
      environment.systemPackages = with pkgs; [
        py
        mpremote
        esptool
        picotool
        openocd-rp2040
      ];
    };
}
