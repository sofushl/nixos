# Copyright (C) 2026 Sofus Højberg Lind
# SPDX-License-Identifier: AGPL-3.0-or-later

{
  # RECCOMENDED PRESERVATION OF "$HOME/.m2" "$HOME/.local/share/JetBrains" "$HOME/.config/JetBrains"

  flake.nixosModules.javaFx =
    { lib, pkgs, ... }:
    let
      libs =
        with pkgs;
        [
          mesa
          glib
          libGL
          libglvnd
          libpulseaudio
          libva
          libx11
          libxtst
          libxrender
          libxext
          libxi
          libxcursor
          libxrandr
          libxxf86vm
          libxfixes
          libxinerama
        ]
        ++ schema;

      schema = with pkgs; [
        gtk3
        gsettings-desktop-schemas
      ];
    in
    {

      programs = {
        java = {
          enable = true;
          package = pkgs.openjdk25;
          binfmt = true;
        };

        nix-ld = {
          enable = true;
          libraries = libs;
        };
      };

      environment = {
        systemPackages = [ pkgs.maven ] ++ libs ++ schema;

        variables = {
          JAVA_HOME = "${pkgs.openjdk}";
          GSETTINGS_SCHEMA_DIR = (lib.concatStringsSep ":" (map pkgs.glib.getSchemaPath schema));
        };

        shellAliases = {
          javafx = "env LD_LIBRARY_PATH=${lib.makeLibraryPath libs}";
          mvn = "env LD_LIBRARY_PATH=${lib.makeLibraryPath libs} mvn";
        };

      };
    };
}
