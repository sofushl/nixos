# Copyright (C) 2026 Sofus Højberg Lind
# SPDX-License-Identifier: AGPL-3.0-or-later

{
  flake.nixosModules.python =
    { pkgs, ... }:

    let
      py = pkgs.python314.withPackages (
        ps: with ps; [
          debugpy
          python-dotenv

          openai
          ollama
          discordpy

          folium
          osmnx

          wheel
          virtualenv
          debugpy

          matplotlib
          statsmodels
          numpy
          numba
          scipy

          requests
          beautifulsoup4

          pygame
          seaborn
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
